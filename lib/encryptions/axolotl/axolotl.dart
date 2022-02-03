import 'dart:ffi';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/encryptions/axolotl/axolotl_interface.dart';
import 'package:lib_omemo_encrypt/encryptions/axolotl/ed25519.dart';
import 'package:lib_omemo_encrypt/keys/prekey.dart';
import 'package:lib_omemo_encrypt/keys/signed_prekey.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_package.dart';
import 'package:lib_omemo_encrypt/utils/array_buffer_utils.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

class Axololt extends AxololtInterface {
  // final algorithm = Ed25519();
  final algorithmX25519 = X25519();
  @override
  Future<SimpleKeyPair> generateKeyPair() async {
    return await algorithmX25519.newKeyPair();
  }

  @override
  Future<SimpleKeyPair> generateIdentityKeyPair() async {
    return await generateKeyPair();
  }

  @override
  Future<PreKey> generateLastResortPreKey() async {
    return PreKey(id: 0xffffff, keyPair: await generateKeyPair());
  }

  @override
  Future<List<PreKey>> generatePreKeys(int start, int count) async {
    List<PreKey> results = [];
    start--;
    for (var i = 0; i < count; i++) {
      results.add(PreKey(
          id: ((start + i) % 0xfffffe) + 1, keyPair: await generateKeyPair()));
    }
    return results;
  }

  @override
  String generateRegistrationId() {
    return Utils.createCryptoRandomString(32);
  }

  @override

  ///
  ///XEdDSA
  /// OMEMO does not mandate the usage of XEdDSA [10] with X3DH [9] for the IdentityKey. Instead, there are three simple rules that implementations MUST follow:
  /// Implementations must use the birational map between the curves Curve25519 and Ed25519 to convert the public part of the IdentityKey whenever required, as defined in RFC 7748 [11] (on page 5).
  /// Implementations must be able to perform X25519 (ECDH on Curve25519) using the IdentityKey.
  /// Implementations must be able to create EdDSA-compatible signatures on the curve Ed25519 using the IdentityKey.
  /// There are essentially two ways in which libraries can fulfill these requirements:
  /// Libraries can use a Curve25519 key pair as their internal IdentityKey. In this case, the IdentityKey can be used for X25519 directly, and XEdDSA has to be used to produce EdDSA-compatible signatures. Note that libsignal by default does NOT use XEdDSA. libsignal includes XEdDSA though and has to be modified to use that to be compatible with OMEMO.
  /// Libraries can use an Ed25519 key pair as their internal IdentityKey. In this case, the IdentityKey can create EdDSA-compatible signatures directly, and has to be converted first to perform X25519.
  Future<SimpleKeyPair> generateSignedPreKey(
      SimpleKeyPair identityKeyPair, int signedPreKeyId) async {
    // Generate a keypair.
    final keyPair = await generateKeyPair();
    return keyPair;
  }

  @override

  /// Sign using Elliptic Curve Digital Signature Algorithm (ECDSA) using P256
  Future<Uint8List> generateSignature(
      SimpleKeyPair identityKeyPair, SimpleKeyPair signedPreKey) async {
    // Generate a keypair.
    // final algorithm = Ed25519();
    // final signature = await algorithm.sign(
    //     (await signedPreKey.extractPublicKey()).bytes,
    //     keyPair: identityKeyPair);
    // return signature;

    final privateKey = await identityKeyPair.extractPrivateKeyBytes();
    final message =
        Uint8List.fromList((await signedPreKey.extractPublicKey()).bytes);

    final signature = sign(
        Uint8List.fromList(privateKey), message, Utils.generateRandomBytes());
    return signature;
  }

  @override
  decryptPreKeyWhisperMessage() {
    // TODO: implement decryptPreKeyWhisperMessage
    throw UnimplementedError();
  }

  @override
  encryptMessage() {
    // TODO: implement encryptMessage
    throw UnimplementedError();
  }

  @override
  Future<PreKeyPackage> generatePreKeysPackage(int preKeyCount) async {
    final identityKeyPair = await generateIdentityKeyPair();
    const signedPreKeyPairId = 1;
    final signedPreKey =
        await generateSignedPreKey(identityKeyPair, signedPreKeyPairId);
    final signature = await generateSignature(identityKeyPair, signedPreKey);

    return PreKeyPackage(
        identityKeyPair: identityKeyPair,
        registrationId: generateRegistrationId(),
        preKeys:
            await generatePreKeys(Utils.createRandomSequence(), preKeyCount),
        signedPreKeyPair: signedPreKey,
        signedPreKeyPairId: signedPreKeyPairId,
        signature: signature);
  }

  @override
  Future<bool> verifySignature(
      Uint8List data, Uint8List signature, PublicKey publicKey) async {
    // final algorithm = Ed25519();
    // final signatureKey = Signature(signature, publicKey: publicKey);
    // final validSignature =
    //     await algorithm.verify(data, signature: signatureKey);
    // return validSignature;
    final publicKeyData =
        Uint8List.fromList((publicKey as SimplePublicKey).bytes);
    final validSignature = verifySig(publicKeyData, data, signature);
    return validSignature;
  }

  @override
  // sHould be using algorithmX25519 keys
  Future<ByteBuffer> calculateAgreement(
      SimpleKeyPair keypair, PublicKey publicKey) async {
    return ArrayBufferUtils.getBytesBuffer((await algorithmX25519
        .sharedSecretKey(keyPair: keypair, remotePublicKey: publicKey)));
  }
}
