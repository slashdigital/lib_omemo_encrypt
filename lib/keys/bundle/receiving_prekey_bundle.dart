import 'dart:typed_data';

import 'package:lib_omemo_encrypt/keys/whisper/identity_key.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';

class ReceivingPreKeyBundle {
  final String userId;
  final IdentityKey identityKey;
  final PreKey preKey;
  final SignedPreKey? signedPreKey;
  final Uint8List signature;

  int get preKeyId => preKey.preKeyId;
  int get signedPreKeyId => signedPreKey!.signedPreKeyId;

  const ReceivingPreKeyBundle(
      {required this.userId,
      required this.identityKey,
      required this.preKey,
      required this.signedPreKey,
      required this.signature});
}
