import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:lib_omemo_encrypt/encryptions/axolotl/axolotl.dart';
import 'package:lib_omemo_encrypt/encryptions/cbc/cbc.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/session_cipher_interface.dart';
import 'package:lib_omemo_encrypt/messages/message.dart';
import 'package:lib_omemo_encrypt/messages/omemo_message.dart';
import 'package:lib_omemo_encrypt/rachet/chain.dart';
import 'package:lib_omemo_encrypt/rachet/message_key.dart';
import 'package:lib_omemo_encrypt/rachet/rachet.dart';
import 'package:lib_omemo_encrypt/sessions/session.dart';
import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/sessions/session_state.dart';
import 'package:lib_omemo_encrypt/utils/log.dart';
import 'package:tuple/tuple.dart';

const maximumMissedMessages = 2000;
const tag = 'SessionCipher';

class SessionCipher extends SessionCipherInterface {
  final Rachet rachet = Rachet();
  final axololt = Axololt();

  @override
  Future<Tuple2<SessionState, Chain>> clickMainRatchet(
      SessionState sessionState,
      SimplePublicKey theirEphemeralPublicKey) async {
    final receiverChain = await rachet.deriveNextRootKeyAndChain(
        sessionState.rootKey,
        theirEphemeralPublicKey,
        sessionState.senderRatchetKeyPair);

    final ourNewEphemeralKeyPair = await axololt.generateKeyPair();

    final senderChain = await rachet.deriveNextRootKeyAndChain(
        receiverChain.rootKey, theirEphemeralPublicKey, ourNewEphemeralKeyPair);

    final newState = SessionState(
      localIdentityKey: sessionState.localIdentityKey,
      sessionVersion: sessionState.sessionVersion,
      remoteIdentityKey: sessionState.remoteIdentityKey,
      rootKey: senderChain.rootKey,
      senderRatchetKeyPair: ourNewEphemeralKeyPair,
      sendingChain: senderChain.chain,
    );
    newState.addReceivingChain(theirEphemeralPublicKey, receiverChain.chain);
    return Tuple2<SessionState, Chain>(newState, receiverChain.chain);
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
      Session session, List<int> paddedMessage) async {
    final messageKeys = await rachet
        .deriveMessageKeys(session.mostRecentState().sendingChain.key);

    // AES-CBC with 128 bit keys and HMAC-SHA256 authentication.
    final algorithm = AesCbc.with256bits(
      macAlgorithm: Hmac.sha256(),
    );
    List<int> _paddedMessage = pad(Uint8List.fromList(paddedMessage), 16);
    final _ciphertext = await algorithm.encrypt(_paddedMessage,
        secretKey: SecretKey(messageKeys.cipherKey), nonce: messageKeys.iv);
    final cipertext = _ciphertext.concatenation(nonce: true, mac: true);

    Log.instance.d(
        tag, 'ciphertext - mac (secret box): ${cipertext.length} :  cipertext');

    final MessageVersion version = MessageVersion(
        session.mostRecentState().sessionVersion, currentVersion);
    final message = OmemoMessage(
      ratchetKey: await session
          .mostRecentState()
          .senderRatchetKeyPair
          .extractPublicKey(),
      counter: session.mostRecentState().sendingChain.index,
      previousCounter: session.mostRecentState().previousCounter,
      ciphertext: cipertext,
    );

    Log.instance.d(tag, 'Rachet key: ${message.ratchetKey.bytes}');
    Log.instance.d(tag, 'Counter: ${message.counter}');
    Log.instance.d(tag, 'previousCounter: ${message.previousCounter}');
    Log.instance.d(tag, 'ciphertext: ${message.ciphertext}');

    final macInputBytes = Message.message.encodeWhisperMessageMacInput(
      version,
      message,
    );

    Log.instance.d(tag, 'macInputBytes: $macInputBytes');
    Log.instance.d(tag, 'messageKeys.macKey: ${messageKeys.macKey}');

    final whisperMessage = Message.message.encodeWhisperMessage(
        version,
        message,
        await getMac(
            macInputBytes,
            messageKeys.macKey,
            session.mostRecentState().sessionVersion,
            session.mostRecentState().localIdentityKey,
            session.mostRecentState().remoteIdentityKey));
    Log.instance.d(tag, 'full message: $whisperMessage');
    return whisperMessage;
  }

  @override
  Future<DecryptedMessage> decryptPreKeyWhisperMessage(
      Session session, Uint8List omemoExchangeMessageBytes) {
    final keyExchangeMessage =
        Message.message.decodePreKeyWhisperMessage(omemoExchangeMessageBytes);
    return decryptWhisperMessage(
        session, Uint8List.fromList(keyExchangeMessage.message.message));
  }

  @override
  Future<DecryptedMessage> decryptWhisperMessage(
      Session session, Uint8List omemoExchangeMessageBytes) async {
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
        return DecryptedMessage(session: newSession, plainText: result.item2);
      }
    }
    throw Exception("Unable to decrypt message: ");
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

    Log.instance.d(tag, 'Decrypting - macInputTypes: $macInputTypes');
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
    Log.instance.d(tag,
        'Decrypting - theirEphemeralPublicKey: ${theirEphemeralPublicKey.bytes}');
    final receivingChain =
        await getOrCreateReceivingChain(sessionState, theirEphemeralPublicKey);
    final _newSessionState = receivingChain.item1;
    final messageKeys = await getOrCreateMessageKeys(_newSessionState,
        theirEphemeralPublicKey, receivingChain.item2, message.n);
    Log.instance.d(tag, 'Decrypting - messageKeys.mac: ${messageKeys.macKey}');
    final newSessionState = receivingChain.item1;
    final isValid = await isValidMac(
        macInputTypes,
        messageKeys.macKey,
        omemoMessage.version.current,
        newSessionState.remoteIdentityKey,
        newSessionState.localIdentityKey,
        omemoMessage.mac);
    if (!isValid) {
      throw Exception('Bad Mac');
    }

    // AES-CBC with 128 bit keys and HMAC-SHA256 authentication.
    final algorithm = AesCbc.with256bits(
      macAlgorithm: Hmac.sha256(),
    );
    final plainText = await algorithm.decrypt(
        SecretBox.fromConcatenation(message.ciphertext,
            nonceLength: 16, macLength: 32),
        secretKey: SecretKey(messageKeys.cipherKey));
    final _plainText = unpad(Uint8List.fromList(plainText));
    newSessionState.pending = null;
    Log.instance.d(tag, 'Plain text: ${utf8.decode(_plainText)}');
    print('Plain text: ${utf8.decode(_plainText)}');
    return Tuple2<SessionState, Uint8List>(newSessionState, _plainText);
  }

  @override
  Future<EncryptedMessage> encryptMessage(
      Session session, List<int> message) async {
    final newSession = Session();
    newSession.clone(session.states);
    final whisperMessage = await createWhisperMessage(newSession, message);
    await rachet.clickSubRachet(newSession.mostRecentState().sendingChain);
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
  }

  @override
  Future<Uint8List> getMac(
      Uint8List data,
      Uint8List macKey,
      int messageVersion,
      SimplePublicKey senderIdentityKey,
      SimplePublicKey receiverIdentityKey) async {
    final mac = crypto.Hmac(crypto.sha256, macKey);

    // final mac = await hmac.calculateMac(
    //   ArrayBufferUtils.concat(macInputs),
    //   secretKey: SecretKey(macKey),
    // );

    final output = AccumulatorSink<crypto.Digest>();
    if (messageVersion >= 3) {
      mac.startChunkedConversion(output)
        ..add(senderIdentityKey.bytes)
        ..add(receiverIdentityKey.bytes)
        ..add(data)
        ..close();
    } else {
      mac.startChunkedConversion(output)
        ..add(data)
        ..close();
    }
    final fullMac = Uint8List.fromList(output.events.single.bytes);
    Log.instance
        .d(tag, 'macInputs - senderIdentityKey: ${senderIdentityKey.bytes}');
    Log.instance.d(
        tag, 'macInputs - receiverIdentityKey: ${receiverIdentityKey.bytes}');
    Log.instance.d(tag, 'macInputs - data: $data');
    Log.instance.d(tag, 'full Mac: $fullMac');
    Log.instance.d(tag,
        'short Mac: ${Uint8List.fromList(fullMac.sublist(0, macByteCount))}');
    return fullMac.sublist(0, macByteCount);

    // return Uint8List.fromList(mac.bytes.sublist(0, macByteCount));
  }

  @override

  /// Chain will reference from passing to out, expecting index + 1
  Future<MessageKey> getOrCreateMessageKeys(SessionState sessionState,
      SimplePublicKey theirEphemeralPublicKey, Chain chain, int counter) async {
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
      // As we have received the message, we should click the sub ratchet forwards so we can't decrypt it again

      Log.instance.d(tag, 'Before - _chain index: ${chain.index}');
      Log.instance.d(tag, 'Before - _chain key: ${chain.key}');
      var messageKeys = await rachet.deriveMessageKeys(chain.key);
      print(messageKeys);
      await rachet.clickSubRachet(chain);
      // Set next chain
      sessionState.setReceivingChain(theirEphemeralPublicKey, chain);
      Log.instance.d(tag, 'After - _chain index: ${chain.index}');
      Log.instance.d(tag, 'After - _chain key: ${chain.key}');
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
      SimplePublicKey senderIdentityKey,
      SimplePublicKey receiverIdentityKey,
      Uint8List theirMac) async {
    var ourMac = await getMac(
        data, macKey, messageVersion, senderIdentityKey, receiverIdentityKey);
    Log.instance.d(tag, 'ourmac: $ourMac');
    Log.instance.d(tag, 'theirMac: $theirMac');
    return crypto.Digest(ourMac) == crypto.Digest(theirMac);
  }
}
