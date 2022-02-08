import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';

void main() {
  final algorithm = X25519();
  group('keys/bundle/prekey.dart', () {
    test('Should serialize pre key pair and parse it back', () async {
      final keyPair = ECDHKeyPair.create(await algorithm.newKeyPair());
      final preKeyPair = PreKeyPair.create(preKeyId: 1, key: keyPair);
      final serialized = await preKeyPair.serialize();

      final parsedKeyPair = await PreKeyPair().deserialize(serialized);

      final serializedFromNewKey = await parsedKeyPair.serialize();
      expect(serialized, serializedFromNewKey);
    });
    test('Should serialize pre key (public) and parse it back', () async {
      final keyPair = ECDHKeyPair.create(await algorithm.newKeyPair());
      final preKeyPair = PreKeyPair.create(preKeyId: 1, key: keyPair);
      final preKey = await preKeyPair.preKey;
      final serialized = await preKey.serialize();

      final parsedKeyPair = await PreKey().deserialize(serialized);

      final serializedFromNewKey = await parsedKeyPair.serialize();
      expect(serialized, serializedFromNewKey);
    });
  });
}
