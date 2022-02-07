import 'dart:ffi';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/encryptions/cbc/cbc.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/group/group_key_state.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/group/group_session_cipher_interface.dart';
import 'package:lib_omemo_encrypt/messages/whisper_sender_message.dart';
import 'package:lib_omemo_encrypt/sessions/session_group.dart';
import 'package:lib_omemo_encrypt/storage/group_storage_interface.dart';
import 'package:lib_omemo_encrypt/storage/in-memory/group_memory_storage.dart';

class GroupSessionCipher extends GroupSessionCipherInterface {
  final GroupStorageInterface groupSessionStore;
  final SessionGroup groupSessionSender;

  GroupSessionCipher(this.groupSessionStore, this.groupSessionSender);

// GroupCipher(this._senderKeyStore, this._senderKeyId);

  @override
  decrypt(Uint8List senderKeyMessageBytes) async {
    final record =
        await groupSessionStore.loadSessionGroupKey(groupSessionSender);
    if (record.isEmpty) {
      throw Exception(
          'No group sender key for: ${groupSessionSender.toString()}');
    }

    final senderKeyMessage =
        WhisperSenderMessage.fromBytes(senderKeyMessageBytes);
    final senderKeyState = record.getSenderKeyStateById(senderKeyMessage.keyId);
    senderKeyMessage.verifySignature(senderKeyState.signingKeyPublic);

    final senderKey = getSenderKey(senderKeyState, senderKeyMessage.iteration);

    // AES-CBC with 128 bit keys and HMAC-SHA256 authentication.
    final algorithm = AesCbc.with256bits(
      macAlgorithm: Hmac.sha256(),
    );
    final plainText = await algorithm.decrypt(
        SecretBox.fromConcatenation(senderKeyMessage.ciphertext,
            nonceLength: 16, macLength: 32),
        secretKey: SecretKey(senderKey.cipherKey));
    final _plainText = unpad(Uint8List.fromList(plainText));

    // final plaintext = aesCbcDecrypt(
    //     senderKey.cipherKey, senderKey.iv, senderKeyMessage.ciphertext);

    await groupSessionStore.storeSessionGroupKey(groupSessionSender, record);
    return _plainText;
  }

  @override
  encrypt(Uint8List paddedMessage) async {
    final record =
        await groupSessionStore.loadSessionGroupKey(groupSessionSender);
    final senderKeyState = record.getSenderKeyState();
    final senderKey = senderKeyState.senderChainKey.senderMessageKey;
    final algorithm = AesCbc.with256bits(
      macAlgorithm: Hmac.sha256(),
    );
    List<int> _paddedMessage = pad(Uint8List.fromList(paddedMessage), 16);
    final _ciphertext = await algorithm.encrypt(_paddedMessage,
        secretKey: SecretKey(senderKey.cipherKey), nonce: senderKey.iv);
    final ciphertext = _ciphertext.concatenation(nonce: true, mac: true);

    final senderKeyMessage = await WhisperSenderMessage.create(
        senderKeyState.keyId,
        senderKey.iteration,
        ciphertext,
        await senderKeyState.signingKeyPrivate);
    final nextSenderChainKey = senderKeyState.senderChainKey.next;
    senderKeyState.senderChainKey = nextSenderChainKey;
    await groupSessionStore.storeSessionGroupKey(groupSessionSender, record);
    return senderKeyMessage.serialized;
  }

  @override
  getSenderKey(SenderKeyState senderKeyState, int iteration) {
    var senderChainKey = senderKeyState.senderChainKey;
    if (senderChainKey.iteration > iteration) {
      if (senderKeyState.hasSenderMessageKey(iteration)) {
        return senderKeyState.removeSenderMessageKey(iteration)!;
      } else {
        throw Exception('Received message with old counter: '
            '${senderChainKey.iteration} , $iteration');
      }
    }

    if (iteration - senderChainKey.iteration > 2000) {
      throw Exception('Over 2000 messages into the future!');
    }

    while (senderChainKey.iteration < iteration) {
      senderKeyState.addSenderMessageKey(senderChainKey.senderMessageKey);
      senderChainKey = senderChainKey.next;
    }

    senderKeyState.senderChainKey = senderChainKey.next;
    return senderChainKey.senderMessageKey;
  }
}
