import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_keypair.dart';

void main() {
  final algorithm = X25519();
  group('keys/bundle/identity_keypair.dart', () {
    test('Should serialize identity and parse it back', () async {
      final xKeyPair = await algorithm.newKeyPair();
      final keyPair =
          ECDHKeyPair.createPair(xKeyPair, await xKeyPair.extractPublicKey());
      final identityKeyPair = IdentityKeyPair.create(key: keyPair);
      final serialized = await identityKeyPair.serialize();

      final parsedKeyPair = await IdentityKeyPair().deserialize(serialized);

      final serializedFromNewKey = await parsedKeyPair.serialize();
      expect(serialized, serializedFromNewKey);
    });
  });
}
