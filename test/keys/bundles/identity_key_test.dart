import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_key.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_keypair.dart';

void main() {
  final algorithm = X25519();
  group('keys/bundle/identity_key.dart', () {
    test('Should serialize identity and parse it back', () async {
      final keyPair = ECDHKeyPair.create(await algorithm.newKeyPair());
      final publicKey = await keyPair.publicKey;
      final identityKey = IdentityKey.create(key: publicKey);
      final serialized = await identityKey.serialize();

      final parsedKeyPair = await IdentityKey().deserialize(serialized);

      final serializedFromNewKey = await parsedKeyPair.serialize();
      expect(serialized, serializedFromNewKey);
    });
  });
}
