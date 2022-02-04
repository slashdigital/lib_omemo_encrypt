import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/key.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_key.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';

class AliceCipherSessionParams {
  final int sessionVersion;
  final ECDHKeyPair ourBaseKeyPair;
  final IdentityKeyPair ourIdentityKeyPair;
  final SignedPreKey? ourSignedPreKeyPair;
  final IdentityKey theirIdentityKey;
  final SignedPreKey theirSignedPreKey;
  final SignedPreKey theirRatchetKey;
  final PreKey? theirOneTimePreKey;

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
