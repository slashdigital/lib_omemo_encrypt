import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';

const countPreKeys = 20;

void main() {
  final encryption = Axololt();
  test('should generate identity key', () async {
    final identityKeyPair = await encryption.generateIdentityKeyPair();
    expect(identityKeyPair.runtimeType, SimpleKeyPairData);
  });
  test('should generate registration id', () {
    final regId = encryption.generateRegistrationId();
    expect(regId.runtimeType, String);
  });
  test('should generate prekeys', () async {
    final prekeys = await encryption.generatePreKeys(
        Utils.createRandomSequence(), countPreKeys);
    expect(prekeys.length, countPreKeys);
    expect(prekeys[0].runtimeType, PreKey);
  });
  test('should generate last resort key', () async {
    final lastResortPreKey = await encryption.generateLastResortPreKey();
    expect(lastResortPreKey.runtimeType, PreKey);
  });
  test('should generate signed pre key', () async {
    final identityKeyPair = await encryption.generateIdentityKeyPair();
    final signedPreKey =
        await encryption.generateSignedPreKey(identityKeyPair, 1);
    expect(signedPreKey.runtimeType, SignedPreKey);
  });
  test('should verify signed pre key signature', () async {
    // final algorithm = Ecdsa.p256(Sha256());

    final identityKeyPair = await encryption.generateIdentityKeyPair();
    final signedPreKey =
        await encryption.generateSignedPreKey(identityKeyPair, 1);
    final signature =
        await encryption.generateSignature(identityKeyPair, signedPreKey);

    final validSignature = await encryption.verifySignature(
        Uint8List.fromList((await signedPreKey.extractPublicKey()).bytes),
        Uint8List.fromList(signature.bytes),
        await identityKeyPair.extractPublicKey());

    expect(validSignature, true);
  });
  test('should calculate the agreement between identity key and public key',
      () async {
    // final algorithm = Ecdsa.p256(Sha256());

    final identityKeyPair = await encryption.generateIdentityKeyPair();
    final signedPreKey =
        await encryption.generateSignedPreKey(identityKeyPair, 1);

    final agreement1 = await encryption.calculateAgreement(
        identityKeyPair, (await signedPreKey.extractPublicKey()));

    expect(agreement1.lengthInBytes, 32);
  });
}
