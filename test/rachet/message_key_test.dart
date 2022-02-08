import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/rachet/message_key.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

void main() {
  group('keys/bundle/identity_key.dart', () {
    test('Should serialize identity and parse it back', () async {
      final messageKey = MessageKey.create(
          cipherKey: Uint8List.fromList(Utils.convertStringToBytes('key')),
          macKey: Uint8List.fromList(Utils.convertStringToBytes('mac')),
          iv: Uint8List.fromList(Utils.convertStringToBytes('iv')));
      final serialized = await messageKey.serialize();

      final parsedKeyPair = await MessageKey().deserialize(serialized);

      final serializedFromNewKey = await parsedKeyPair.serialize();
      expect(serialized, serializedFromNewKey);
    });
  });
}
