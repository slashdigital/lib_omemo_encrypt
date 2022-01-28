import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/constants/constant.dart';

import 'package:lib_omemo_encrypt/encryptions/cipher_session/cipher_session_interface.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/cipher_session_params.dart';
import 'package:lib_omemo_encrypt/exceptions/invalid_key_exception.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';
import 'package:lib_omemo_encrypt/keys/noob/nokey_pair.dart';
import 'package:lib_omemo_encrypt/keys/noob/noprekey.dart';
import 'package:lib_omemo_encrypt/keys/noob/nosigned_prekey.dart';
import 'package:lib_omemo_encrypt/keys/pending_prekey.dart';
import 'package:lib_omemo_encrypt/rachet/key_and_chain.dart';
import 'package:lib_omemo_encrypt/rachet/rachet.dart';
import 'package:lib_omemo_encrypt/sessions/session.dart';
import 'package:lib_omemo_encrypt/sessions/session_state.dart';
import 'package:lib_omemo_encrypt/storage/storage_interface.dart';
import 'package:lib_omemo_encrypt/utils/array_buffer_utils.dart';

class CipherSession extends CipherSessionInterface {
  final Rachet rachet = Rachet();
  final algorithmx25519 = X25519();
  final algorithmEd25519 = Ed25519();
  final StorageInterface store;

  CipherSession({required this.store});

  @override
  createSessionFromPreKeyBundle(PreKeyBundle receivingPreKeyBundle) async {
    if (receivingPreKeyBundle.signedPreKey is! NoSignedPreKey) {
      final validSignature = await algorithmEd25519.verify(
          (await receivingPreKeyBundle.identityKeyPair.extractPrivateKeyBytes())
              .toList(),
          signature: receivingPreKeyBundle.signedPreKey.signature);
      if (!validSignature) {
        throw InvalidKeyException('Invalid signature on device key');
      }
    }
    if (receivingPreKeyBundle.preKey is NoKeyPair &&
        receivingPreKeyBundle.signedPreKey is NoSignedPreKey) {
      throw InvalidKeyException('Both signed and unsigned pre keys are absent');
    }
    final supportsV3 = receivingPreKeyBundle.signedPreKey is! NoSignedPreKey;
    final ourBaseKeyPair = await algorithmx25519.newKeyPair();
    final theirSignedPreKey = supportsV3
        ? receivingPreKeyBundle.signedPreKey
        : receivingPreKeyBundle.preKey;

    final aliceParameters = CipherSessionParams(
        sessionVersion: supportsV3 ? 3 : 2,
        ourBaseKeyPair: ourBaseKeyPair,
        ourIdentityKeyPair: store.getLocalIdentityKeyPair(),
        theirIdentityKey: receivingPreKeyBundle.identityKeyPair,
        theirSignedPreKey: theirSignedPreKey,
        theirRatchetKey: theirSignedPreKey,
        theirOneTimePreKey:
            supportsV3 ? receivingPreKeyBundle.preKey : NoPreKey());

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
      CipherSessionParams aliceParameters) async {
    final sendingRatchetKeyPair = await algorithmx25519.newKeyPair();
    final agreement1 = await ArrayBufferUtils.getBytesBuffer(
        (await algorithmx25519.sharedSecretKey(
            keyPair: aliceParameters.ourIdentityKeyPair,
            remotePublicKey: await aliceParameters.theirSignedPreKey.keyPair
                .extractPublicKey())));
    final agreement2 = await ArrayBufferUtils.getBytesBuffer(
        (await algorithmx25519.sharedSecretKey(
            keyPair: aliceParameters.ourBaseKeyPair,
            remotePublicKey:
                await aliceParameters.theirIdentityKey.extractPublicKey())));
    final agreement3 = await ArrayBufferUtils.getBytesBuffer(
        (await algorithmx25519.sharedSecretKey(
            keyPair: aliceParameters.ourBaseKeyPair,
            remotePublicKey: await aliceParameters.theirSignedPreKey.keyPair
                .extractPublicKey())));
    final agreements = [agreement1, agreement2, agreement3];

    if (aliceParameters.sessionVersion >= 3 &&
        aliceParameters.theirOneTimePreKey is! NoPreKey) {
      final agreement4 = await ArrayBufferUtils.getBytesBuffer(
          (await algorithmx25519.sharedSecretKey(
              keyPair: aliceParameters.ourBaseKeyPair,
              remotePublicKey: await aliceParameters.theirOneTimePreKey.keyPair
                  .extractPublicKey())));
      agreements.add(agreement4);
    }
    final KeyAndChain initialRootKeyChain = rachet.deriveInitialRootKeyAndChain(
        aliceParameters.sessionVersion, agreements);
    final KeyAndChain nextRootKeyChain = rachet.deriveInitialRootKeyAndChain(
        aliceParameters.sessionVersion, agreements);
    final SessionState sessionState = SessionState(
      sessionVersion: aliceParameters.sessionVersion,
      remoteIdentityKey: aliceParameters.theirIdentityKey,
      localIdentityKey: aliceParameters.ourIdentityKeyPair,
      rootKey: nextRootKeyChain.rootKey,
      sendingChain: nextRootKeyChain.chain,
      senderRatchetKeyPair: sendingRatchetKeyPair,
    );
    sessionState.addReceivingChain(
        aliceParameters.theirRatchetKey, initialRootKeyChain.chain);
    return sessionState;

    //     var sessionState = new SessionState({
    //         sessionVersion: parameters.sessionVersion,
    //         remoteIdentityKey: parameters.theirIdentityKey,
    //         localIdentityKey: parameters.ourIdentityKeyPair.public,
    //         rootKey: rootKey,
    //         sendingChain: sendingChain,
    //         senderRatchetKeyPair: sendingRatchetKeyPair
    //     });
    //     sessionState.addReceivingChain(parameters.theirRatchetKey, receivingChain);
    //     return sessionState;

    // var sendingRatchetKeyPair = yield crypto.generateKeyPair();

    //     var agreements = [
    //         crypto.calculateAgreement(parameters.theirSignedPreKey, parameters.ourIdentityKeyPair.private),
    //         crypto.calculateAgreement(parameters.theirIdentityKey, parameters.ourBaseKeyPair.private),
    //         crypto.calculateAgreement(parameters.theirSignedPreKey, parameters.ourBaseKeyPair.private)
    //     ];
    //     if (parameters.sessionVersion >= 3 && parameters.theirOneTimePreKey) {
    //         agreements.push(crypto.calculateAgreement(parameters.theirOneTimePreKey,
    //             parameters.ourBaseKeyPair.private));
    //     }
    //     var {
    //         rootKey: theirRootKey,
    //         chain: receivingChain
    //     } = yield ratchet.deriveInitialRootKeyAndChain(parameters.sessionVersion, yield agreements);
    //     var {
    //         rootKey,
    //         chain: sendingChain
    //     } = yield ratchet.deriveNextRootKeyAndChain(theirRootKey, parameters.theirRatchetKey,
    //             sendingRatchetKeyPair.private);

    //     var sessionState = new SessionState({
    //         sessionVersion: parameters.sessionVersion,
    //         remoteIdentityKey: parameters.theirIdentityKey,
    //         localIdentityKey: parameters.ourIdentityKeyPair.public,
    //         rootKey: rootKey,
    //         sendingChain: sendingChain,
    //         senderRatchetKeyPair: sendingRatchetKeyPair
    //     });
    //     sessionState.addReceivingChain(parameters.theirRatchetKey, receivingChain);
    //     return sessionState;
  }

  // // Sign
  // final message = <int>[1,2,3];
  // final signature = await algorithm.sign(
  //   message,
  //   keyPair: keyPair,
  // );
  // print('Signature bytes: ${signature.bytes}');
  // print('Public key: ${signature.publicKey.bytes}');

  // // Anyone can verify the signature
  // final isVerified = await ed25519.verify(
  //   message,
  //   signature: signature,
  // );
}
