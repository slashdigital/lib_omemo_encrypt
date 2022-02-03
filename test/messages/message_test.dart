import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/messages/message.dart';
import 'package:lib_omemo_encrypt/messages/omemo_message.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

void main() {
  final algorithm = X25519();
  group('message/message.dart', () {
    test('Should encode message', () async {
      final keyPair = await algorithm.newKeyPair();
      final result = Message.message.encodeWhisperMessageMacInput(
          MessageVersion(3, 3),
          OmemoMessage(
              ratchetKey: await keyPair.extractPublicKey(),
              counter: 0,
              previousCounter: 0,
              ciphertext:
                  Uint8List.fromList(Utils.convertStringToBytes('test'))));
      final decoded = Message.message.decodePreKeyWhisperMessage(result);
    });
  });
}
