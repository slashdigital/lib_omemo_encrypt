import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';

class PreKeyPackage {
  final SimpleKeyPair identityKeyPair;
  final String registrationId;
  final List<PreKey> preKeys;
  final int signedPreKeyPairId;
  final SimpleKeyPair signedPreKeyPair;
  final Signature signature;

  const PreKeyPackage(
      {required this.identityKeyPair,
      required this.registrationId,
      required this.preKeys,
      required this.signedPreKeyPairId,
      required this.signedPreKeyPair,
      required this.signature});
}
