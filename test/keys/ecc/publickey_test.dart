import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';

void main() {
  final algorithm = X25519();
  group('keys/ecc/public_key.dart', () {
    test('Should serialize and parse it back', () async {
      final keyPair = ECDHKeyPair.create(await algorithm.newKeyPair());
      final publicKey = await keyPair.publicKey;
      final serialized = await publicKey.serialize();
      final parsedKeyPair = await ECDHPublicKey().deserialize(serialized);

      final serializedFromNewKey = await parsedKeyPair.serialize();
      expect(serialized, serializedFromNewKey);
    });
  });
}
