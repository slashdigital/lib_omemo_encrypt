import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/encryptions/axolotl/axolotl.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

const countPreKeys = 20;

void main() {
  final encryption = Axololt();
  test('should generate identity key', () async {
    final identityKeyPair = await encryption.generateIdentityKeyPair();
    expect(identityKeyPair.runtimeType, IdentityKeyPair);
  });
  test('should generate registration id', () {
    final regId = encryption.generateRegistrationId();
    expect(regId.runtimeType, String);
  });
  test('should generate prekeys', () async {
    final prekeys = await encryption.generatePreKeys(
        Utils.createRandomSequence(), countPreKeys);
    expect(prekeys.length, countPreKeys);
    expect(prekeys[0].runtimeType, PreKeyPair);
  });
  test('should generate last resort key', () async {
    final lastResortPreKey = await encryption.generateLastResortPreKey();
    expect(lastResortPreKey.runtimeType, PreKeyPair);
  });
  test('should generate signed pre key', () async {
    final signedPreKey = await encryption.generateSignedPreKey(1);
    expect(signedPreKey.runtimeType, SignedPreKey);
  });
  test('should verify signed pre key signature', () async {
    // final algorithm = Ecdsa.p256(Sha256());

    final identityKeyPair = await encryption.generateIdentityKeyPair();
    final signedPreKey = await encryption.generateSignedPreKey(1);
    final signature =
        await encryption.generateSignature(identityKeyPair, signedPreKey);

    final validSignature = await encryption.verifySignature(
        await signedPreKey.keyPair.publicKeyBytes,
        signature,
        await identityKeyPair.keyPair.publicKey);

    expect(validSignature, true);
  });
  test('should calculate the agreement between identity key and public key',
      () async {
    final identityKeyPair = await encryption.generateIdentityKeyPair();
    final signedPreKey = await encryption.generateSignedPreKey(1);

    final agreement1 = await encryption.calculateAgreement(
        identityKeyPair.keyPair, (await signedPreKey.keyPair.publicKey));

    expect(agreement1.lengthInBytes, 32);
  });
}
