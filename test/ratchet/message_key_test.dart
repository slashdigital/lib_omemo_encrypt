import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/ratchet/message_key.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

void main() {
  group('ratchet/message_key.dart', () {
    test('Should serialize message key and parse it back', () async {
      final messageKey = MessageKey.create(
          cipherKey: Uint8List.fromList(Utils.convertStringToBytes('key')),
          macKey: Uint8List.fromList(Utils.convertStringToBytes('mac')),
          iv: Uint8List.fromList(Utils.convertStringToBytes('iv')));
      final serialized = await messageKey.serialize();

      final parsedMsgkey = await MessageKey().deserialize(serialized);

      final serializedFromNewMsgKey = await parsedMsgkey.serialize();
      expect(serialized, serializedFromNewMsgKey);
    });
  });
}
