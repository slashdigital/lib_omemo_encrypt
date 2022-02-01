import 'dart:typed_data';

import 'package:lib_omemo_encrypt/encryptions/cipher_session/session_cipher_interface.dart';
import 'package:lib_omemo_encrypt/messages/message.dart';
import 'package:lib_omemo_encrypt/messages/omemo_message.dart';
import 'package:lib_omemo_encrypt/rachet/chain.dart';
import 'package:lib_omemo_encrypt/rachet/message_key.dart';
import 'package:lib_omemo_encrypt/rachet/rachet.dart';
import 'package:lib_omemo_encrypt/sessions/session.dart';
import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/sessions/session_state.dart';
import 'package:lib_omemo_encrypt/utils/array_buffer_utils.dart';
import 'package:tuple/tuple.dart';

const maximumMissedMessages = 2000;

class SessionCipher extends SessionCipherInterface {
  final Rachet rachet = Rachet();

  @override
  Future<Tuple2<SessionState, Chain>> clickMainRatchet(
      SessionState sessionState,
      SimplePublicKey theirEphemeralPublicKey) async {
    final rootKeychain = await rachet.deriveNextRootKeyAndChain(
        sessionState.rootKey,
        theirEphemeralPublicKey,
        sessionState.senderRatchetKeyPair);
    final ourNewEphemeralKeyPair = await rachet.algorithmx25519.newKeyPair();
    final nextRootKeychain = await rachet.deriveNextRootKeyAndChain(
        rootKeychain.rootKey, theirEphemeralPublicKey, ourNewEphemeralKeyPair);
    final newState = SessionState(
      localIdentityKey: sessionState.localIdentityKey,
      sessionVersion: sessionState.sessionVersion,
      remoteIdentityKey: sessionState.remoteIdentityKey,
      rootKey: nextRootKeychain.rootKey,
      senderRatchetKeyPair: ourNewEphemeralKeyPair,
      sendingChain: nextRootKeychain.chain,
    );
    return Tuple2<SessionState, Chain>(newState, rootKeychain.chain);
    // var {
    //       rootKey: theirRootKey,
    //       chain: nextReceivingChain
    //   } = yield ratchet.deriveNextRootKeyAndChain(sessionState.rootKey, theirEphemeralPublicKey,
    //           sessionState.senderRatchetKeyPair.private);
    //   var ourNewEphemeralKeyPair = yield crypto.generateKeyPair();
    //   var {
    //       rootKey,
    //       chain: nextSendingChain
    //   } = yield ratchet.deriveNextRootKeyAndChain(theirRootKey,
    //           theirEphemeralPublicKey, ourNewEphemeralKeyPair.private);
    //   sessionState.rootKey = rootKey;
    //   sessionState.addReceivingChain(theirEphemeralPublicKey, nextReceivingChain);
    //   sessionState.previousCounter = Math.max(sessionState.sendingChain.index - 1, 0);
    //   sessionState.sendingChain = nextSendingChain;
    //   sessionState.senderRatchetKeyPair = ourNewEphemeralKeyPair;
    //   return nextReceivingChain;
  }

  @override
  Future<Uint8List> createPreKeyWhisperMessage(
      Session session, Uint8List whisperMessage) async {
    final pendingPreKey = session.mostRecentState().pending;
    return await Message.message.encodePreKeyWhisperMessage(
        MessageVersion(
            session.mostRecentState().sessionVersion, currentVersion),
        KeyExchangeMessage(
            registrationId: session.mostRecentState().localRegistrationId,
            preKeyId: pendingPreKey!.preKeyId,
            signedPreKeyId: pendingPreKey.signedPreKeyId,
            baseKey: pendingPreKey.baseKey,
            identityKey: session.mostRecentState().localIdentityKey,
            message: whisperMessage));
  }

  @override
  Future<Uint8List> createWhisperMessage(
      Session session, dynamic paddedMessage) async {
    final messageKeys = await rachet
        .deriveMessageKeys(session.mostRecentState().sendingChain.key);

    // AES-CBC with 128 bit keys and HMAC-SHA256 authentication.
    final algorithm = AesCbc.with256bits(
      macAlgorithm: Hmac.sha256(),
    );
    final ciphertext = await algorithm.encrypt(paddedMessage,
        secretKey: SecretKey(messageKeys.cipherKey), nonce: messageKeys.iv);
    // var messageKeys = yield ratchet.deriveMessageKeys(session.mostRecentState().sendingChain.key);
    //     // TODO: Should use CTR mode in version 2 of protocol
    //     var ciphertext = yield crypto.encrypt(messageKeys.cipherKey, paddedMessage, messageKeys.iv);
    final MessageVersion version = MessageVersion(
        session.mostRecentState().sessionVersion, currentVersion);
    //     var version = {
    //         current: session.mostRecentState().sessionVersion,
    //         max: ProtocolConstants.currentVersion
    //     };
    //     var message = {
    //         ratchetKey: session.mostRecentState().senderRatchetKeyPair.public,
    //         counter: session.mostRecentState().sendingChain.index,
    //         previousCounter: session.mostRecentState().previousCounter,
    //         ciphertext: ciphertext
    //     };
    final message = OmemoMessage(
      ratchetKey: await session
          .mostRecentState()
          .senderRatchetKeyPair
          .extractPublicKey(),
      counter: session.mostRecentState().sendingChain.index,
      previousCounter: session.mostRecentState().previousCounter,
      ciphertext: ciphertext,
    );

    //     var macInputBytes = Messages.encodeWhisperMessageMacInput({
    //         version: version,
    //         message: message
    //     });

    final macInputBytes = Message.message.encodeWhisperMessageMacInput(
      version,
      message,
    );

    return Message.message.encodeWhisperMessage(
        version,
        message,
        await getMac(
            macInputBytes,
            messageKeys.macKey,
            session.mostRecentState().sessionVersion,
            session.mostRecentState().localIdentityKey,
            session.mostRecentState().remoteIdentityKey));

    // return Message.message.encodeWhisperMessage();

    //     return Messages.encodeWhisperMessage({
    //         version: version,
    //         message: message,
    //         mac: yield getMac(macInputBytes, messageKeys.macKey, session.mostRecentState().sessionVersion,
    //             session.mostRecentState().localIdentityKey,
    //             session.mostRecentState().remoteIdentityKey)
    //     });
  }

  @override
  decryptPreKeyWhisperMessage(
      Session session, Uint8List omemoExchangeMessageBytes) {
    final keyExchangeMessage =
        Message.message.decodePreKeyWhisperMessage(omemoExchangeMessageBytes);
    return decryptWhisperMessage(
        session, Uint8List.fromList(keyExchangeMessage.message.message));
    // var preKeyWhisperMessage = Messages.decodePreKeyWhisperMessage(preKeyWhisperMessageBytes);
    // return self.decryptWhisperMessage(
    //     session, preKeyWhisperMessage.message.message);
  }

  @override
  decryptWhisperMessage(
      Session session, Uint8List omemoExchangeMessageBytes) async {
    // // TODO: implement decryptWhisperMessage
    // throw UnimplementedError();
    // var newSession = new Session(session);
    final newSession = Session();
    newSession.clone(session.states);
    for (var element in newSession.states) {
      final clonedSessionState = SessionState(
          sessionVersion: element.sessionVersion,
          remoteIdentityKey: element.remoteIdentityKey,
          localIdentityKey: element.localIdentityKey,
          rootKey: element.rootKey,
          sendingChain: element.sendingChain,
          senderRatchetKeyPair: element.senderRatchetKeyPair);
      final result = await decryptWhisperMessageWithSessionState(
          clonedSessionState, omemoExchangeMessageBytes);
      if (result != null) {
        newSession.removeState(element);
        newSession.addState(result.item1);
        return {
          'message': result,
          'session': newSession,
        };
      }
    }
    throw Exception("Unable to decrypt message: ");
    // var newSession = new Session(session);
    //   var exceptions = [];
    //   for (var state of newSession.states) {
    //       var clonedSessionState = new SessionState(state);
    //       var promise = decryptWhisperMessageWithSessionState(clonedSessionState, whisperMessageBytes);
    //       var result = yield promise.catch((e) => {
    //           exceptions.push(e);
    //       });
    //       if (result !== undefined) {
    //           newSession.removeState(state);
    //           newSession.addState(clonedSessionState);
    //           return {
    //               message: result,
    //               session: newSession
    //           };
    //       }
    //   }
    //   var messages = exceptions.map((e) => e.toString());
    //   throw new InvalidMessageException("Unable to decrypt message: " + messages);
  }

  @override
  Future<Tuple2<SessionState, Uint8List>?>
      decryptWhisperMessageWithSessionState(SessionState sessionState,
          Uint8List omemoExchangeMessageBytes) async {
    // try {
    // var whisperMessage = Messages.decodeWhisperMessage(whisperMessageBytes);
    final omemoMessage =
        Message.message.decodeWhisperMessage(omemoExchangeMessageBytes);
    final macInputTypes =
        Message.message.decodeWhisperMessageMacInput(omemoExchangeMessageBytes);

    //     var macInputTypes = Messages.decodeWhisperMessageMacInput(whisperMessageBytes);

    //     if (whisperMessage.version.current !== sessionState.sessionVersion) {
    //         throw new InvalidMessageException("Message version doesn't match session version");
    //     }
    if (omemoMessage.version.current != sessionState.sessionVersion) {
      throw Exception("Message version doesn't match session version");
    }
    final message = omemoMessage.message;
    final theirEphemeralPublicKey =
        SimplePublicKey(message.dhPub, type: KeyPairType.x25519);
    final receivingChain =
        await getOrCreateReceivingChain(sessionState, theirEphemeralPublicKey);
    final messageKeys =
        await getOrCreateMessageKeys(receivingChain.item2, message.n);
    final newSessionState = receivingChain.item1;
    final isValid = await isValidMac(
        macInputTypes,
        messageKeys.macKey,
        omemoMessage.version.current,
        newSessionState.remoteIdentityKey,
        newSessionState.localIdentityKey,
        omemoMessage.mac);
    // if (!isValid) {
    //   throw Exception('Bad Mac');
    // }

    // AES-CBC with 128 bit keys and HMAC-SHA256 authentication.
    final algorithm = AesCbc.with256bits(
      macAlgorithm: Hmac.sha256(),
    );
    final plainText = await algorithm.decrypt(
        SecretBox(message.ciphertext,
            nonce: messageKeys.iv, mac: Mac(macInputTypes)),
        secretKey: SecretKey(messageKeys.cipherKey));
    newSessionState.pending = null;
    return Tuple2<SessionState, Uint8List>(
        newSessionState, Uint8List.fromList(plainText));
    // } catch (e) {
    // return null;
    // }
    //     var message = whisperMessage.message;
    //     var theirEphemeralPublicKey = message.ratchetKey;

    //     var receivingChain = yield getOrCreateReceivingChain(sessionState, theirEphemeralPublicKey);
    //     var messageKeys = yield getOrCreateMessageKeys(theirEphemeralPublicKey, receivingChain, message.counter);
    //     var isValid = yield isValidMac(macInputTypes, messageKeys.macKey, whisperMessage.version.current,
    //         sessionState.remoteIdentityKey, sessionState.localIdentityKey, whisperMessage.mac);

    //     if (!isValid) {
    //         throw new InvalidMessageException("Bad mac");
    //     }

    //     // TODO: Support for version 2: Use CTR mode instead of CBC
    //     var plaintext = yield crypto.decrypt(messageKeys.cipherKey, message.ciphertext, messageKeys.iv);

    //     sessionState.pendingPreKey = null;

    //     return plaintext;
  }

  @override
  Future<EncryptedMessage> encryptMessage(
      Session session, List<int> message) async {
    final newSession = Session();
    newSession.clone(session.states);
    final whisperMessage = await createWhisperMessage(newSession, message);
    // is.encryptMessage = co.wrap(function*(session, message) {
    //     var newSession = new Session(session);
    //     var whisperMessage = yield createWhisperMessage(newSession, message);
    rachet.clickSubRachet(newSession.mostRecentState().sendingChain);
    if (newSession.mostRecentState().pending != null) {
      return EncryptedMessage(
          isPreKeyWhisperMessage: true,
          body: await createPreKeyWhisperMessage(newSession, whisperMessage),
          session: newSession);
    } else {
      return EncryptedMessage(
          isPreKeyWhisperMessage: false,
          body: whisperMessage,
          session: newSession);
    }

    //     yield ratchet.clickSubRatchet(newSession.mostRecentState().sendingChain);

    //     if (newSession.mostRecentState().pendingPreKey) {
    //         return {
    //             isPreKeyWhisperMessage: true,
    //             body: createPreKeyWhisperMessage(newSession, whisperMessage),
    //             session: newSession
    //         };
    //     } else {
    //         return {
    //             isPreKeyWhisperMessage: false,
    //             body: whisperMessage,
    //             session: newSession
    //         };
    //     }
    // });
  }

  @override
  Future<Uint8List> getMac(
      Uint8List data,
      Uint8List macKey,
      int messageVersion,
      SimpleKeyPair senderIdentityKey,
      SimpleKeyPair receiverIdentityKey) async {
    List<ByteBuffer> macInputs = (messageVersion >= 3)
        ? [
            Uint8List.fromList((await senderIdentityKey.extract()).bytes)
                .buffer,
            Uint8List.fromList((await receiverIdentityKey.extract()).bytes)
                .buffer
          ]
        : [];
    macInputs.add(data.buffer);
    final hmac = Hmac.sha256();

    final mac = await hmac.calculateMac(
      ArrayBufferUtils.concat(macInputs),
      secretKey: SecretKey(macKey),
    );
    return Uint8List.fromList(mac.bytes.sublist(0, macByteCount));
  }

  @override
  Future<MessageKey> getOrCreateMessageKeys(Chain chain, int counter) async {
    if (chain.index > counter) {
      // The message is an old message that has been delivered out of order. We should still have the message
      // key cached unless this is a duplicate message that we've seen before.
      var cachedMessageKeys = chain.messageKeys[counter];
      if (cachedMessageKeys != null) {
        throw Exception("Received message with old counter");
      }
      // We don't want to be able to decrypt this message again, for forward secrecy.
      chain.messageKeys.remove(cachedMessageKeys);
      return cachedMessageKeys!;
    } else {
      // Otherwise, the message is a new message in the chain and we must click the sub ratchet forwards.
      if (counter - chain.index > maximumMissedMessages) {
        throw Exception("Too many skipped messages");
      }
      while (chain.index < counter) {
        // Some messages have not yet been delivered ("skipped") and so we need to catch the sub ratchet up
        // while keeping the message keys for when the messages are eventually delivered.
        chain.messageKeys[chain.index] =
            await rachet.deriveMessageKeys(chain.key);
        await rachet.clickSubRachet(chain);
      }
      var messageKeys = await rachet.deriveMessageKeys(chain.key);
      // As we have received the message, we should click the sub ratchet forwards so we can't decrypt it again
      await rachet.clickSubRachet(chain);
      return messageKeys;
    }
  }

  @override
  Future<Tuple2<SessionState, Chain>> getOrCreateReceivingChain(
      SessionState sessionState,
      SimplePublicKey theirEphemeralPublicKey) async {
    var chain = sessionState.findReceivingChain(theirEphemeralPublicKey);
    if (chain != null) {
      return Tuple2<SessionState, Chain>(sessionState, chain);
    }
    // This is the first message in a new chain.
    return await clickMainRatchet(sessionState, theirEphemeralPublicKey);
  }

  @override
  Future<bool> isValidMac(
      Uint8List data,
      Uint8List macKey,
      int messageVersion,
      SimpleKeyPair senderIdentityKey,
      SimpleKeyPair receiverIdentityKey,
      Uint8List theirMac) async {
    var ourMac = await getMac(
        data, macKey, messageVersion, senderIdentityKey, receiverIdentityKey);
    return ourMac == theirMac;
  }
}
