import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';

class BobCipherSessionParams {
  final int sessionVersion;
  final SimplePublicKey theirBaseKey;
  final SimplePublicKey theirIdentityKey;
  final SignedPreKey ourSignedPreKeyPair;
  final SimpleKeyPair ourIdentityKeyPair;
  final SignedPreKey ourRatchetKeyPair;
  final PreKey? ourOneTimePreKeyPair;

  const BobCipherSessionParams({
    required this.sessionVersion,
    required this.theirBaseKey,
    required this.theirIdentityKey,
    required this.ourIdentityKeyPair,
    required this.ourSignedPreKeyPair,
    required this.ourRatchetKeyPair,
    required this.ourOneTimePreKeyPair,
  });
}
