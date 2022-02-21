import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/pending_prekey.dart';

void main() {
  final algorithm = X25519();
  group('keys/bundle/pending_pre_key.dart', () {
    test('Should serialize pending pre key pair and parse it back', () async {
      final xKeyPair = await algorithm.newKeyPair();
      final keyPair =
          ECDHKeyPair.createPair(xKeyPair, await xKeyPair.extractPublicKey());
      final publicKey = await keyPair.publicKey;
      final pendingPreKey =
          PendingPreKey.create(signedPreKeyId: 1, preKeyId: 2, key: publicKey);
      final serialized = await pendingPreKey.serialize();

      final parsedKeyPair = await PendingPreKey().deserialize(serialized);

      final serializedFromNewKey = await parsedKeyPair.serialize();
      expect(serialized, serializedFromNewKey);
    });
  });
}
