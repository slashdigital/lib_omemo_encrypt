import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';

class PreKeyBundle {
  final String userId;
  final SimpleKeyPair identityKeyPair;
  final String registrationId;
  final PreKey preKey;
  final SignedPreKey signedPreKey;

  const PreKeyBundle(
      {required this.userId,
      required this.identityKeyPair,
      required this.registrationId,
      required this.preKey,
      required this.signedPreKey});
}
