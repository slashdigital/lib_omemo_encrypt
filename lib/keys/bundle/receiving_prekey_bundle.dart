import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';

class ReceivingPreKeyBundle {
  final String userId;
  final SimpleKeyPair identityKeyPair;
  final String registrationId;
  final SimplePublicKey preKey;
  final SignedPreKey? signedPreKey;
  final int preKeyId;
  final int signedPreKeyId;

  const ReceivingPreKeyBundle(
      {required this.userId,
      required this.identityKeyPair,
      required this.registrationId,
      required this.preKey,
      required this.signedPreKey,
      required this.preKeyId,
      required this.signedPreKeyId});
}
