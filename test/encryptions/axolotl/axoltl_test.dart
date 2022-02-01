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
    final algorithmEd25519 = Ed25519();
    final identityKeyPair = await encryption.generateIdentityKeyPair();
    final signedPreKey =
        await encryption.generateSignedPreKey(identityKeyPair, 1);

    final validSignature = await algorithmEd25519.verify(
        (await identityKeyPair.extractPrivateKeyBytes()).toList(),
        signature: signedPreKey.signature);
    expect(validSignature, true);
  });
}