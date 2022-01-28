import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/keys/key.dart';
import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';

class CipherSessionParams {
  final int sessionVersion;
  final KeyPair ourBaseKeyPair;
  final KeyPair ourIdentityKeyPair;
  final KeyPair theirIdentityKey;
  final LibOMEMOKey theirSignedPreKey;
  final LibOMEMOKey theirRatchetKey;
  final PreKey theirOneTimePreKey;

  const CipherSessionParams(
      {required this.sessionVersion,
      required this.ourBaseKeyPair,
      required this.ourIdentityKeyPair,
      required this.theirIdentityKey,
      required this.theirSignedPreKey,
      required this.theirRatchetKey,
      required this.theirOneTimePreKey});

  //         sessionVersion: supportsV3 ? 3 : 2,
  //         ourBaseKeyPair: ourBaseKeyPair,
  //         ourIdentityKeyPair: yield store.getLocalIdentityKeyPair(),
  //         theirIdentityKey: retrievedPreKeyBundle.identityKey,
  //         theirSignedPreKey: theirSignedPreKey,
  //         theirRatchetKey: theirSignedPreKey,
  //         theirOneTimePreKey: supportsV3 ? retrievedPreKeyBundle.preKey : undefined
}
