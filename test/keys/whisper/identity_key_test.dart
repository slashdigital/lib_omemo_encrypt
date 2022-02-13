import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_key.dart';
import 'package:lib_omemo_encrypt/keys/whisper/whisper_key.dart';

main() {
  final publicKey = ECDHPublicKey();

  group('Test IdentityKey', () {  
    test('Get the keytype', () {
      IdentityKey ik = IdentityKey.create(key: publicKey);
      final WhisperKeyType actual = ik.keyType;

      const expected = WhisperKeyType.identityKey;
      
      expect(actual, expected);
    });

    test('The runtime type shall be correct', () {
      IdentityKey ik = IdentityKey.create(key: publicKey);

      final actual = ik.type;
      final expected = publicKey.runtimeType;

      expect(actual, expected);
    });
  });
}