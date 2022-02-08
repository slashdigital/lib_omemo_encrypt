import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/ratchet/chain.dart';
import 'package:lib_omemo_encrypt/ratchet/message_key.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

void main() {
  group('keys/bundle/identity_key.dart', () {
    test('Should serialize identity and parse it back', () async {
      final messageKey = MessageKey.create(
          cipherKey: Uint8List.fromList(Utils.convertStringToBytes('key')),
          macKey: Uint8List.fromList(Utils.convertStringToBytes('mac')),
          iv: Uint8List.fromList(Utils.convertStringToBytes('iv')));
      final messageKeyNext = MessageKey.create(
          cipherKey: Uint8List.fromList(Utils.convertStringToBytes('key_next')),
          macKey: Uint8List.fromList(Utils.convertStringToBytes('mac_next')),
          iv: Uint8List.fromList(Utils.convertStringToBytes('iv_next')));

      final chain = Chain.create(
          Uint8List.fromList(Utils.convertStringToBytes('chainKeys')),
          index: 0,
          messageKeys: [messageKey, messageKeyNext]);
      final serialized = await chain.serialize();

      final parsedKeyPair = await Chain().deserialize(serialized);

      final serializedFromNewKey = await parsedKeyPair.serialize();
      expect(serialized, serializedFromNewKey);
    });
  });
}
