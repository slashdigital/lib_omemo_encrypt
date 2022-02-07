import 'dart:typed_data';

import 'package:lib_omemo_encrypt/encryptions/axolotl/ed25519.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';
import 'package:lib_omemo_encrypt/utils/array_buffer_utils.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';
import 'package:lib_omemo_encrypt/protobuf/WhisperSenderMessage.pb.dart'
    as whisper_msg;

class WhisperSenderMessage {
  static const currentVersion = 3;
  static const int signatureLength = 64;
  final int messageVersion;
  final int keyId;
  final int iteration;
  final Uint8List ciphertext;
  final ECDHKeyPair? signatureKey;
  final Uint8List serialized;

  const WhisperSenderMessage(
      {required this.keyId,
      required this.iteration,
      required this.ciphertext,
      required this.signatureKey,
      required this.serialized,
      required this.messageVersion});

  static Future<WhisperSenderMessage> create(int keyId, int iteration,
      Uint8List ciphertext, ECDHKeyPair signatureKey) async {
    final version = Uint8List.fromList(
        [Utils.intsToByteHighAndLow(currentVersion, currentVersion)]);

    final byteBuffer = whisper_msg.SenderKeyMessage(
            ciphertext: ciphertext, id: keyId, iteration: iteration)
        .writeToBuffer()
        .buffer;
    final signature = await _getSignature(
        signatureKey, ArrayBufferUtils.concat([version.buffer, byteBuffer]));

    return WhisperSenderMessage(
        keyId: keyId,
        iteration: iteration,
        ciphertext: ciphertext,
        messageVersion: currentVersion,
        serialized: ArrayBufferUtils.concat(
            [version.buffer, byteBuffer, signature.buffer]),
        signatureKey: signatureKey);
  }

  static WhisperSenderMessage fromBytes(Uint8List bytes) {
    final version = bytes.sublist(0, 1)[0];
    final message = bytes.sublist(1, bytes.length - signatureLength);
    // final signature = bytes.sublist(bytes.length - signatureLength);

    if (Utils.highBitsToInt(version) < 3) {
      throw Exception('Legacy message: ${Utils.highBitsToInt(version)}');
    }

    if (Utils.highBitsToInt(version) > currentVersion) {
      throw Exception('Unknown version: ${Utils.highBitsToInt(version)}');
    }

    final parsedMessage = whisper_msg.SenderKeyMessage.fromBuffer(message);

    if (!parsedMessage.hasId() ||
        !parsedMessage.hasIteration() ||
        !parsedMessage.hasCiphertext()) {
      throw Exception('Incomplete message.');
    }

    return WhisperSenderMessage(
        keyId: parsedMessage.id,
        iteration: parsedMessage.iteration,
        ciphertext: Uint8List.fromList(parsedMessage.ciphertext),
        messageVersion: Utils.highBitsToInt(version),
        serialized: bytes,
        signatureKey: null);

    // serialized = bytes;
    // messageVersion = Utils.highBitsToInt(version);
    // keyId = parsedMessage.id;
    // iteration = parsedMessage.iteration;
    // ciphertext = Uint8List.fromList(parsedMessage.ciphertext);
  }

  static Future<Uint8List> _getSignature(
      ECDHKeyPair signatureKey, Uint8List serializedMessage) async {
    try {
      final privateKeyBytes = await signatureKey.bytes;
      final signature = sign(Uint8List.fromList(privateKeyBytes),
          serializedMessage, Utils.generateRandomBytes());
      return signature;
    } catch (e) {
      throw AssertionError(e);
    }
  }

  Future<void> verifySignature(ECDHPublicKey signatureKey) async {
    try {
      final message =
          serialized.sublist(0, serialized.length - signatureLength);
      final signature = serialized.sublist(serialized.length - signatureLength);
      final publicKeyBytes = await signatureKey.bytes;
      final verified = verifySig(publicKeyBytes, message, signature);

      if (!verified) {
        throw Exception('Invalid signature!');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
