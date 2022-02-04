import 'dart:typed_data';

import 'package:lib_omemo_encrypt/keys/whisper/identity_keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';

class PreKeyPackage {
  final IdentityKeyPair identityKeyPair;
  final String registrationId;
  final List<PreKeyPair> preKeys;
  final int signedPreKeyPairId;
  final SignedPreKey signedPreKeyPair;
  final Uint8List signature;

  const PreKeyPackage(
      {required this.identityKeyPair,
      required this.registrationId,
      required this.preKeys,
      required this.signedPreKeyPairId,
      required this.signedPreKeyPair,
      required this.signature});
}
