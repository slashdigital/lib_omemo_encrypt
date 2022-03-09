import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/ratchet/chain.dart';
import 'package:lib_omemo_encrypt/ratchet/message_key.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

void main() {
  group('ratchet/chain.dart', () {
    test('Should serialize chain and parse it back', () async {
      final messageKey = MessageKey.create(
          cipherKey: Uint8List.fromList(Utils.convertStringToBytes('key')),
          macKey: Uint8List.fromList(Utils.convertStringToBytes('mac')),
          iv: Uint8List.fromList(Utils.convertStringToBytes('iv')),
          index: 0);
      final messageKeyNext = MessageKey.create(
          cipherKey: Uint8List.fromList(Utils.convertStringToBytes('key_next')),
          macKey: Uint8List.fromList(Utils.convertStringToBytes('mac_next')),
          iv: Uint8List.fromList(Utils.convertStringToBytes('iv_next')),
          index: 1);

      final chain = Chain.create(
          Uint8List.fromList(Utils.convertStringToBytes('chainKeys')),
          index: 0,
          messageKeysList: [messageKey, messageKeyNext]);
      final serialized = await chain.serialize();

      final parsedChain = await Chain().deserialize(serialized);

      final serializedFromNewChain = await parsedChain.serialize();
      expect(serialized, serializedFromNewChain);
    });
  });
}
