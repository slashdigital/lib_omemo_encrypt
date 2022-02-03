import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/keys/prekey.dart';
import 'package:lib_omemo_encrypt/keys/signed_prekey.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_package.dart';

abstract class AxololtInterface {
  Future<SimpleKeyPair> generateKeyPair();
  Future<SimpleKeyPair> generateIdentityKeyPair();
  String generateRegistrationId();
  Future<List<PreKey>> generatePreKeys(int start, int count);
  Future<PreKey> generateLastResortPreKey();
  Future<SimpleKeyPair> generateSignedPreKey(
      SimpleKeyPair identityKeyPair, int signedPreKeyId);
  Future<Uint8List> generateSignature(
      SimpleKeyPair identityKeyPair, SimpleKeyPair signedPreKey);
  Future<bool> verifySignature(
      Uint8List data, Uint8List signature, SimplePublicKey publicKey);
  Future<PreKeyPackage> generatePreKeysPackage(int preKeyCount);
  // Encrypt
  encryptMessage();
  // Decrypt
  decryptPreKeyWhisperMessage();
  Future<ByteBuffer> calculateAgreement(
      SimpleKeyPair keypair, PublicKey publicKey);
}
