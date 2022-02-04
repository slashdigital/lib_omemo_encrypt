import 'package:lib_omemo_encrypt/keys/whisper/identity_key.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';

class BobCipherSessionParams {
  final int sessionVersion;
  final PreKey theirBaseKey;
  final IdentityKey theirIdentityKey;
  final SignedPreKeyPair ourSignedPreKeyPair;
  final IdentityKeyPair ourIdentityKeyPair;
  final SignedPreKeyPair ourRatchetKeyPair;
  final PreKeyPair? ourOneTimePreKeyPair;

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
