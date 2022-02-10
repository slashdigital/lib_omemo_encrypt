import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:lib_omemo_encrypt/encryptions/axolotl/axolotl_interface.dart';
import 'package:lib_omemo_encrypt/encryptions/axolotl/ed25519.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_package.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';
// import 'package:lib_omemo_encrypt/keys/prekey.dart';
// import 'package:lib_omemo_encrypt/keys/bundle/prekey_package.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';
import 'package:lib_omemo_encrypt/utils/array_buffer_utils.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

class Axololt extends AxololtInterface {
  final algorithmX25519 = X25519();
  @override
  Future<ECDHKeyPair> generateKeyPair() async {
    return ECDHKeyPair.create(await algorithmX25519.newKeyPair());
  }

  @override
  Future<IdentityKeyPair> generateIdentityKeyPair() async {
    return IdentityKeyPair.create(key: await generateKeyPair());
  }

  @override
  Future<PreKeyPair> generateLastResortPreKey() async {
    return PreKeyPair.create(preKeyId: 0xffffff, key: await generateKeyPair());
  }

  @override
  Future<List<PreKeyPair>> generatePreKeys(int start, int count) async {
    List<PreKeyPair> results = [];
    start--;
    for (var i = 0; i < count; i++) {
      results.add(PreKeyPair.create(
          preKeyId: ((start + i) % 0xfffffe) + 1,
          key: await generateKeyPair()));
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
  Future<SignedPreKeyPair> generateSignedPreKey(int signedPreKeyId) async {
    // Generate a keypair.
    final keyPair = SignedPreKeyPair.create(
        key: await generateKeyPair(), signedPreKeyId: signedPreKeyId);
    return keyPair;
  }

  @override

  /// Sign using Elliptic Curve Digital Signature Algorithm (ECDSA) using P256
  Future<Uint8List> generateSignature(
      IdentityKeyPair identityKeyPair, SignedPreKeyPair signedPreKey) async {
    final privateKey = await identityKeyPair.keyPair.bytes;
    final message = await signedPreKey.keyPair.publicKeyBytes;
    final signature = sign(
        Uint8List.fromList(privateKey), message, Utils.generateRandomBytes());
    return signature;
  }

  @override
  Future<PreKeyPackage> generatePreKeysPackage(int preKeyCount) async {
    final identityKeyPair = await generateIdentityKeyPair();
    const signedPreKeyPairId = 1;
    final signedPreKey = await generateSignedPreKey(signedPreKeyPairId);
    final signature = await generateSignature(identityKeyPair, signedPreKey);
    if (kDebugMode) {
      print(
          'New Signature Generation: $signature for ${await (await identityKeyPair.identityKey).key.bytes}');
    }

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
      Uint8List data, Uint8List signature, ECDHPublicKey publicKey) async {
    final publicKeyData = await publicKey.bytes;
    final validSignature = verifySig(publicKeyData, data, signature);
    return validSignature;
  }

  @override
  // sHould be using algorithmX25519 keys
  Future<ByteBuffer> calculateAgreement(
      ECDHKeyPair keypair, ECDHPublicKey publicKey) async {
    return ArrayBufferUtils.getBytesBuffer(
        (await algorithmX25519.sharedSecretKey(
            keyPair: keypair.keyPair, remotePublicKey: await publicKey.key)));
  }
}
