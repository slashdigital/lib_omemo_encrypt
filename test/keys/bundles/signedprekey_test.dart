import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';

void main() {
  final algorithm = X25519();
  group('keys/bundle/signed_pre_key.dart', () {
    test('Should serialize signed pre key pair and parse it back', () async {
      final keyPair = ECDHKeyPair.create(await algorithm.newKeyPair());
      final preKeyPair =
          SignedPreKeyPair.create(signedPreKeyId: 1, key: keyPair);
      final serialized = await preKeyPair.serialize();

      final parsedKeyPair = await PreKeyPair().deserialize(serialized);

      final serializedFromNewKey = await parsedKeyPair.serialize();
      expect(serialized, serializedFromNewKey);
    });
    test('Should serialize signed pre key (public) and parse it back',
        () async {
      final keyPair = ECDHKeyPair.create(await algorithm.newKeyPair());
      final preKeyPair =
          SignedPreKeyPair.create(signedPreKeyId: 1, key: keyPair);
      final signedPreKey = await preKeyPair.signedPreKey;
      final serialized = await signedPreKey.serialize();

      final parsedKeyPair = await SignedPreKey().deserialize(serialized);

      final serializedFromNewKey = await parsedKeyPair.serialize();
      expect(serialized, serializedFromNewKey);
    });
  });
}
