import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/encryptions/axolotl/axolotl.dart';
import 'package:lib_omemo_encrypt/messages/message.dart';
import 'package:lib_omemo_encrypt/messages/omemo_message.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

void main() {
  final axolotl = Axololt();
  group('message/message.dart', () {
    test('Should encode message', () async {
      final keyPair = await axolotl.generateKeyPair();
      final result = await Message.message.encodeWhisperMessageMacInput(
          MessageVersion(3, 3),
          OmemoMessage(
              ratchetKey: await keyPair.publicKey,
              counter: 0,
              previousCounter: 0,
              ciphertext:
                  Uint8List.fromList(Utils.convertStringToBytes('test'))));
      final decoded = Message.message.decodePreKeyWhisperMessage(result);
      expect(decoded.runtimeType, PreKeyWhisperMessage);
    });
  });
}
