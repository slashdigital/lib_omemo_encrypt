import 'package:lib_omemo_encrypt/keys/whisper/identity_keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';

class PreKeyBundle {
  final String userId;
  final IdentityKeyPair identityKeyPair;
  final String registrationId;
  final PreKeyPair preKey;
  final SignedPreKeyPair signedPreKey;

  int get preKeyId => preKey.preKeyId;
  int get signedPreKeyId => signedPreKey.signedPreKeyId;

  const PreKeyBundle({
    required this.userId,
    required this.identityKeyPair,
    required this.registrationId,
    required this.preKey,
    required this.signedPreKey,
  });
}
