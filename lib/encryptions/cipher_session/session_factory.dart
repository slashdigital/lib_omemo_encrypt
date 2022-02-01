import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/constants/constant.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/bob_cipher_session_params.dart';

import 'package:lib_omemo_encrypt/encryptions/cipher_session/session_factory_interface.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/alice_cipher_session_params.dart';
import 'package:lib_omemo_encrypt/exceptions/invalid_key_exception.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';
import 'package:lib_omemo_encrypt/keys/bundle/receiving_prekey_bundle.dart';
import 'package:lib_omemo_encrypt/keys/noob/nokey_pair.dart';
import 'package:lib_omemo_encrypt/keys/noob/noprekey.dart';
import 'package:lib_omemo_encrypt/keys/noob/nopublickey.dart';
import 'package:lib_omemo_encrypt/keys/noob/nosigned_prekey.dart';
import 'package:lib_omemo_encrypt/keys/pending_prekey.dart';
import 'package:lib_omemo_encrypt/messages/message.dart';
import 'package:lib_omemo_encrypt/rachet/key_and_chain.dart';
import 'package:lib_omemo_encrypt/rachet/rachet.dart';
import 'package:lib_omemo_encrypt/sessions/session.dart';
import 'package:lib_omemo_encrypt/sessions/session_state.dart';
import 'package:lib_omemo_encrypt/storage/storage_interface.dart';
import 'package:lib_omemo_encrypt/utils/array_buffer_utils.dart';

class SessionCipherState {
  final Session session;
  late SimplePublicKey identityKey;
  late String registrationId;

  SessionCipherState(
      this.session, List<int> identityKey, List<int> registrationId) {
    this.identityKey = SimplePublicKey(identityKey, type: KeyPairType.x25519);
    this.registrationId = base64Url.encode(registrationId);
  }
}

class SessionFactory extends SessionFactoryInterface {
  final Rachet rachet = Rachet();
  final algorithmx25519 = X25519();
  final algorithmEd25519 = Ed25519();
  final StorageInterface store;

  SessionFactory({required this.store});

  @override
  createSessionFromPreKeyBundle(
      ReceivingPreKeyBundle receivingPreKeyBundle) async {
    if (receivingPreKeyBundle.signedPreKey != null) {
      final validSignature = await algorithmEd25519.verify(
          (await receivingPreKeyBundle.identityKeyPair
              .extractPrivateKeyBytes()),
          signature: receivingPreKeyBundle.signedPreKey!.signature);

      if (!validSignature) {
        throw InvalidKeyException('Invalid signature on device key');
      }
    }
    if (receivingPreKeyBundle.preKey is NoKeyPair &&
        receivingPreKeyBundle.signedPreKey != null) {
      throw InvalidKeyException('Both signed and unsigned pre keys are absent');
    }
    final supportsV3 = receivingPreKeyBundle.signedPreKey != null;
    final ourBaseKeyPair = await algorithmx25519.newKeyPair();
    final SimplePublicKey theirSignedPreKey = supportsV3
        ? await receivingPreKeyBundle.signedPreKey!.keyPair!.extractPublicKey()
        : receivingPreKeyBundle.preKey;

    final aliceParameters = AliceCipherSessionParams(
        sessionVersion: supportsV3 ? 3 : 2,
        ourBaseKeyPair: ourBaseKeyPair,
        ourIdentityKeyPair: store.getLocalIdentityKeyPair(),
        ourSignedPreKeyPair: null,
        theirIdentityKey: receivingPreKeyBundle.identityKeyPair,
        theirSignedPreKey: theirSignedPreKey,
        theirRatchetKey: theirSignedPreKey,
        theirOneTimePreKey: supportsV3 ? receivingPreKeyBundle.preKey : null);

    final sessionState = await initializeAliceSession(aliceParameters);
    sessionState.pending = PendingPreKey(
        preKeyId: supportsV3 ? receivingPreKeyBundle.preKeyId : noPreKeyId,
        baseKey: await ourBaseKeyPair.extractPublicKey(),
        signedPreKeyId: receivingPreKeyBundle.signedPreKeyId);
    sessionState.localRegistrationId = await store.getLocalRegistrationId();

    var session = Session();
    session.addState(sessionState);
    return session;
  }

  @override
  Future<SessionState> initializeAliceSession(
      AliceCipherSessionParams parameters) async {
    final sendingRatchetKeyPair = await algorithmx25519.newKeyPair();
    final agreement1 = await ArrayBufferUtils.getBytesBuffer(
        (await algorithmx25519.sharedSecretKey(
            keyPair: parameters.ourIdentityKeyPair,
            remotePublicKey: parameters.theirSignedPreKey)));
    final agreement2 = await ArrayBufferUtils.getBytesBuffer(
        (await algorithmx25519.sharedSecretKey(
            keyPair: parameters.ourBaseKeyPair,
            remotePublicKey:
                await parameters.theirIdentityKey.extractPublicKey())));
    final agreement3 = await ArrayBufferUtils.getBytesBuffer(
        (await algorithmx25519.sharedSecretKey(
            keyPair: parameters.ourBaseKeyPair,
            remotePublicKey: parameters.theirSignedPreKey)));
    final agreements = [agreement1, agreement2, agreement3];

    if (parameters.sessionVersion >= 3 &&
        parameters.theirOneTimePreKey != null) {
      final agreement4 = await ArrayBufferUtils.getBytesBuffer(
          (await algorithmx25519.sharedSecretKey(
              keyPair: parameters.ourBaseKeyPair,
              remotePublicKey: parameters.theirOneTimePreKey!)));
      agreements.add(agreement4);
    }
    final KeyAndChain initialRootKeyChain = rachet.deriveInitialRootKeyAndChain(
        parameters.sessionVersion, agreements);
    final KeyAndChain nextRootKeyChain = rachet.deriveInitialRootKeyAndChain(
        parameters.sessionVersion, agreements);
    final SessionState sessionState = SessionState(
      sessionVersion: parameters.sessionVersion,
      remoteIdentityKey: parameters.theirIdentityKey,
      localIdentityKey: parameters.ourIdentityKeyPair,
      rootKey: nextRootKeyChain.rootKey,
      sendingChain: nextRootKeyChain.chain,
      senderRatchetKeyPair: sendingRatchetKeyPair,
    );
    sessionState.addReceivingChain(
        parameters.theirRatchetKey, initialRootKeyChain.chain);
    return sessionState;
  }

  @override
  createSessionFromPreKeyWhisperMessage(
      Session session, Uint8List preKeyWhisperMessageBytes) async {
    final preKeyWhisperMessage =
        Message.message.decodePreKeyWhisperMessage(preKeyWhisperMessageBytes);
    if (preKeyWhisperMessage.version.current != 3) {
      throw Exception(
          "Protocol version ${preKeyWhisperMessage.version.current} is not supported");
    }
    //  var preKeyWhisperMessage = Messages.decodePreKeyWhisperMessage(preKeyWhisperMessageBytes);
    //     if (preKeyWhisperMessage.version.current !== 3) {
    //         // TODO: Support protocol version 2
    //         throw new UnsupportedProtocolVersionException("Protocol version " +
    //             preKeyWhisperMessage.version.current + " is not supported");
    //     }
    //     var message = preKeyWhisperMessage.message;

    final message = preKeyWhisperMessage.message;
    //     if (session) {
    //         for (var cachedSessionState of session.states) {
    //             if (cachedSessionState.theirBaseKey &&
    //                 ArrayBufferUtils.areEqual(cachedSessionState.theirBaseKey, message.baseKey)) {
    //                 return {
    //                     session: session,
    //                     identityKey: message.identityKey,
    //                     registrationId: message.registrationId
    //                 };
    //             }
    //         }
    //     }
    // check if existing
    for (var cachedSessionState in session.states) {
      if (cachedSessionState.theirBaseKey != null &&
          cachedSessionState.theirBaseKey!.bytes == message.ek) {
        return SessionCipherState(session, message.ik, message.registrationId);
      }
    }

    // var ourSignedPreKeyPair = yield store.getLocalSignedPreKeyPair(message.signedPreKeyId);
    // TODO: is signed pre key generated all
    final ourSignedPreKeyPair = store.getLocalSignedPreKeyPair(message.spkId);
    final preKeyPair = store.getLocalPreKeyPair(message.pkId);

    // var preKeyPair;
    // if (message.preKeyId !== null) {
    //     preKeyPair = yield store.getLocalPreKeyPair(message.preKeyId);
    // }

    final bobParameters = BobCipherSessionParams(
        sessionVersion: preKeyWhisperMessage.version.current,
        theirBaseKey: SimplePublicKey(message.ek, type: KeyPairType.x25519),
        theirIdentityKey: await algorithmx25519.newKeyPairFromSeed(
            message.ik), //(message.ik, type: KeyPairType.x25519),
        ourIdentityKeyPair: store.getLocalIdentityKeyPair(),
        ourSignedPreKeyPair: ourSignedPreKeyPair,
        ourRatchetKeyPair: ourSignedPreKeyPair,
        ourOneTimePreKeyPair: preKeyPair);

    // var bobParameters = {
    //     sessionVersion: preKeyWhisperMessage.version.current,
    //     theirBaseKey: message.baseKey,
    //     theirIdentityKey: message.identityKey,
    //     ourIdentityKeyPair: yield store.getLocalIdentityKeyPair(),
    //     ourSignedPreKeyPair: ourSignedPreKeyPair,
    //     ourRatchetKeyPair: ourSignedPreKeyPair,
    //     ourOneTimePreKeyPair: preKeyPair
    // };
    final sessionState = await initializeBobSession(bobParameters);
    sessionState.theirBaseKey =
        SimplePublicKey(message.ek, type: KeyPairType.x25519);
    final clonedSession = Session();
    clonedSession.clone(session.states);
    clonedSession.addState(sessionState);
    return SessionCipherState(session, message.ik, message.registrationId);

    // var sessionState = yield initializeBobSession(bobParameters);
    // sessionState.theirBaseKey = message.baseKey;
    // var clonedSession = new Session(session);
    // clonedSession.addState(sessionState);
    // return {
    //     session: clonedSession,
    //     identityKey: message.identityKey,
    //     registrationId: message.registrationId
    // };
  }

  @override
  Future<SessionState> initializeBobSession(
      BobCipherSessionParams parameters) async {
    final agreement1 = await ArrayBufferUtils.getBytesBuffer(
        (await algorithmx25519.sharedSecretKey(
            keyPair: parameters.ourSignedPreKeyPair.keyPair!,
            remotePublicKey:
                await parameters.theirIdentityKey.extractPublicKey())));
    final agreement2 = await ArrayBufferUtils.getBytesBuffer(
        (await algorithmx25519.sharedSecretKey(
            keyPair: parameters.ourIdentityKeyPair,
            remotePublicKey: parameters.theirBaseKey)));
    final agreement3 = await ArrayBufferUtils.getBytesBuffer(
        (await algorithmx25519.sharedSecretKey(
            keyPair: parameters.ourSignedPreKeyPair.keyPair!,
            remotePublicKey: parameters.theirBaseKey)));
    final agreements = [agreement1, agreement2, agreement3];
    //  var agreements = [
    //         crypto.calculateAgreement(parameters.theirIdentityKey, parameters.ourSignedPreKeyPair.private),
    //         crypto.calculateAgreement(parameters.theirBaseKey, parameters.ourIdentityKeyPair.private),
    //         crypto.calculateAgreement(parameters.theirBaseKey, parameters.ourSignedPreKeyPair.private)
    //     ];
    if (parameters.sessionVersion >= 3 &&
        parameters.ourOneTimePreKeyPair != null) {
      final agreement4 = await ArrayBufferUtils.getBytesBuffer(
          (await algorithmx25519.sharedSecretKey(
              keyPair: parameters.ourOneTimePreKeyPair!.keyPair!,
              remotePublicKey: parameters.theirBaseKey)));
      agreements.add(agreement4);
    }

    //     if (parameters.sessionVersion >= 3 && parameters.ourOneTimePreKeyPair) {
    //         agreements.push(crypto.calculateAgreement(parameters.theirBaseKey,
    //             parameters.ourOneTimePreKeyPair.private));
    //     }

    //     var {
    //         rootKey,
    //         chain: sendingChain
    //     } = yield ratchet.deriveInitialRootKeyAndChain(parameters.sessionVersion, yield agreements);
    final KeyAndChain initialRootKeyChain = rachet.deriveInitialRootKeyAndChain(
        parameters.sessionVersion, agreements);
    //     return new SessionState({
    //         sessionVersion: parameters.sessionVersion,
    //         remoteIdentityKey: parameters.theirIdentityKey,
    //         localIdentityKey: parameters.ourIdentityKeyPair.public,
    //         rootKey: rootKey,
    //         sendingChain: sendingChain,
    //         senderRatchetKeyPair: parameters.ourRatchetKeyPair
    //     });

    final SessionState sessionState = SessionState(
      sessionVersion: parameters.sessionVersion,
      remoteIdentityKey: parameters.theirIdentityKey,
      localIdentityKey: parameters.ourIdentityKeyPair,
      rootKey: initialRootKeyChain.rootKey,
      sendingChain: initialRootKeyChain.chain,
      senderRatchetKeyPair: parameters.ourRatchetKeyPair.keyPair!,
    );
    return sessionState;
  }
}
