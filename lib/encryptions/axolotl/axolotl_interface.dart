import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
// import 'package:lib_omemo_encrypt/keys/prekey.dart';
// import 'package:lib_omemo_encrypt/keys/signed_prekey.dart';
// import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_package.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';

abstract class AxololtInterface {
  Future<ECDHKeyPair> generateKeyPair();
  Future<IdentityKeyPair> generateIdentityKeyPair();
  Future<PreKeyPair> generateLastResortPreKey();
  Future<List<PreKeyPair>> generatePreKeys(int start, int count);
  String generateRegistrationId();
  Future<SignedPreKeyPair> generateSignedPreKey(int signedPreKeyId);
  Future<Uint8List> generateSignature(
      IdentityKeyPair identityKeyPair, SignedPreKeyPair signedPreKey);
  Future<bool> verifySignature(
      Uint8List data, Uint8List signature, ECDHPublicKey publicKey);
  Future<PreKeyPackage> generatePreKeysPackage(int preKeyCount);
  Future<ByteBuffer> calculateAgreement(
      ECDHKeyPair keypair, ECDHPublicKey publicKey);
}
