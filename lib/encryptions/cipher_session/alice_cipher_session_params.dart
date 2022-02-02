import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/keys/key.dart';

class AliceCipherSessionParams {
  final int sessionVersion;
  final SimpleKeyPair ourBaseKeyPair;
  final SimpleKeyPair ourIdentityKeyPair;
  final LibOMEMOKey? ourSignedPreKeyPair;
  final SimplePublicKey theirIdentityKey;
  final PublicKey theirSignedPreKey;
  final PublicKey theirRatchetKey;
  final SimplePublicKey? theirOneTimePreKey;

  const AliceCipherSessionParams(
      {required this.sessionVersion,
      required this.ourBaseKeyPair,
      required this.ourIdentityKeyPair,
      required this.ourSignedPreKeyPair,
      required this.theirIdentityKey,
      required this.theirSignedPreKey,
      required this.theirRatchetKey,
      required this.theirOneTimePreKey});
}
