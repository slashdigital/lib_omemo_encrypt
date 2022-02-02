import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';

class OmemoMessage {
  final SimplePublicKey ratchetKey;
  final int counter;
  final int previousCounter;
  final SecretBox ciphertext;

  const OmemoMessage(
      {required this.ratchetKey,
      required this.counter,
      required this.previousCounter,
      required this.ciphertext});
}

class KeyExchangeMessage {
  final String registrationId;
  final int preKeyId;
  final int signedPreKeyId;
  final SimplePublicKey baseKey;
  final SimplePublicKey identityKey;
  final Uint8List message;

  const KeyExchangeMessage(
      {required this.registrationId,
      required this.preKeyId,
      required this.signedPreKeyId,
      required this.baseKey,
      required this.identityKey,
      required this.message});
}

class EncryptedMessage {
  final bool isPreKeyWhisperMessage;
  final Uint8List body;
  final Session session;

  const EncryptedMessage(
      {required this.isPreKeyWhisperMessage,
      required this.body,
      required this.session});
}
