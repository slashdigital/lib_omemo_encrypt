import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/encryptions/axolotl/axolotl_interface.dart';
import 'package:lib_omemo_encrypt/keys/prekey.dart';
import 'package:lib_omemo_encrypt/keys/signed_prekey.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_package.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

class Axololt extends AxololtInterface {
  final algorithm = X25519();
  @override
  Future<SimpleKeyPair> generateIdentityKeyPair() async {
    return await algorithm.newKeyPair();
  }

  @override
  Future<PreKey> generateLastResortPreKey() async {
    return PreKey(id: 0xffffff, keyPair: await algorithm.newKeyPair());
  }

  @override
  Future<List<PreKey>> generatePreKeys(int start, int count) async {
    List<PreKey> results = [];
    start--;
    for (var i = 0; i < count; i++) {
      results.add(PreKey(
          id: ((start + i) % 0xfffffe) + 1,
          keyPair: await algorithm.newKeyPair()));
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
  Future<SignedPreKey> generateSignedPreKey(
      SimpleKeyPair identityKeyPair, int signedPreKeyId) async {
    // Generate a keypair.
    final algorithmEd25519 = Ed25519();
    final keyPair = await algorithm.newKeyPair();
    final signature = await algorithmEd25519
        .sign(await identityKeyPair.extractPrivateKeyBytes(), keyPair: keyPair);
    return SignedPreKey(
        id: signedPreKeyId, keyPair: keyPair, signature: signature);
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
    const signedPreKeyId = 1;
    return PreKeyPackage(
        identityKeyPair: identityKeyPair,
        registrationId: generateRegistrationId(),
        preKeys:
            await generatePreKeys(Utils.createRandomSequence(), preKeyCount),
        signedPreKey:
            await generateSignedPreKey(identityKeyPair, signedPreKeyId));
  }
}
