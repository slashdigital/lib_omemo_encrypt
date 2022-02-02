import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';

class ReceivingPreKeyBundle {
  final String userId;
  final SimplePublicKey identityKey;
  final String registrationId;
  final SimplePublicKey preKey;
  final SimplePublicKey? signedPreKey;
  final int preKeyId;
  final int signedPreKeyId;
  final Uint8List signature;

  const ReceivingPreKeyBundle(
      {required this.userId,
      required this.identityKey,
      required this.registrationId,
      required this.preKey,
      required this.signedPreKey,
      required this.preKeyId,
      required this.signedPreKeyId,
      required this.signature});
}
