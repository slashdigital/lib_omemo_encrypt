import 'dart:typed_data';

import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';
import 'package:lib_omemo_encrypt/utils/array_buffer_utils.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';
import 'package:lib_omemo_encrypt/protobuf/WhisperSenderDistributionMessage.pb.dart'
    as whisper_dist_msg;

class WhisperSenderDistributionMessage {
  static const currentVersion = 3;
  static const int signatureLength = 64;

  final int id;
  final int iteration;
  final Uint8List chainKey;
  final ECDHPublicKey signatureKey;
  final Uint8List serialized;

  const WhisperSenderDistributionMessage(
      {required this.id,
      required this.iteration,
      required this.chainKey,
      required this.signatureKey,
      required this.serialized});
  static Future<WhisperSenderDistributionMessage> create(int id, int iteration,
      Uint8List chainKey, ECDHPublicKey signatureKey) async {
    final version = Uint8List.fromList(
        [Utils.intsToByteHighAndLow(currentVersion, currentVersion)]);
    final protobuf = whisper_dist_msg.SenderKeyDistributionMessage(
            chainKey: chainKey,
            signingKey: await signatureKey.bytes,
            iteration: iteration,
            id: id)
        .writeToBuffer()
        .buffer;

    return WhisperSenderDistributionMessage(
        id: id,
        iteration: iteration,
        chainKey: chainKey,
        signatureKey: signatureKey,
        serialized: ArrayBufferUtils.concat([version.buffer, protobuf]));
  }

  static WhisperSenderDistributionMessage fromBytes(Uint8List bytes) {
    final version = bytes.sublist(0, 1)[0];
    final message = bytes.sublist(1);

    if (Utils.highBitsToInt(version) < currentVersion) {
      throw Exception('Legacy message: ${Utils.highBitsToInt(version)}');
    }
    if (Utils.highBitsToInt(version) > currentVersion) {
      throw Exception('Unknown version: ${Utils.highBitsToInt(version)}');
    }

    final distributionMessages =
        whisper_dist_msg.SenderKeyDistributionMessage.fromBuffer(message);
    if (!distributionMessages.hasId() ||
        !distributionMessages.hasIteration() ||
        !distributionMessages.hasChainKey() ||
        !distributionMessages.hasSigningKey()) {
      throw Exception('Incomplete message.');
    }
    return WhisperSenderDistributionMessage(
        id: distributionMessages.id,
        iteration: distributionMessages.iteration,
        chainKey: Uint8List.fromList(distributionMessages.chainKey),
        signatureKey: ECDHPublicKey.fromBytes(distributionMessages.signingKey),
        serialized: bytes);
  }
}
