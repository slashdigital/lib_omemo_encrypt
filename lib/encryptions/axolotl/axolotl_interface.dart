import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/keys/prekey.dart';
import 'package:lib_omemo_encrypt/keys/signed_prekey.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_package.dart';

abstract class AxololtInterface {
  Future<SimpleKeyPair> generateIdentityKeyPair();
  String generateRegistrationId();
  Future<List<PreKey>> generatePreKeys(int start, int count);
  Future<PreKey> generateLastResortPreKey();
  Future<SignedPreKey> generateSignedPreKey(
      SimpleKeyPair identityKeyPair, int signedPreKeyId);
  Future<PreKeyPackage> generatePreKeysPackage(int preKeyCount);
  // Encrypt
  encryptMessage();
  // Decrypt
  decryptPreKeyWhisperMessage();
}
