import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';

void main() {
  final algorithm = X25519();
  group('keys/ecc/keypair.dart', () {
    test('Should serialize and parse it back', () async {
      final keyPair = ECDHKeyPair.create(await algorithm.newKeyPair());
      final serialized = await keyPair.serialize();
      final parsedKeyPair = await ECDHKeyPair().deserialize(serialized);

      final serializedFromNewKey = await parsedKeyPair.serialize();
      expect(serialized, serializedFromNewKey);
    });
  });
}
