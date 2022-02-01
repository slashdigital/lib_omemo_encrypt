import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/messages/omemo_message.dart';
import 'package:lib_omemo_encrypt/rachet/chain.dart';
import 'package:lib_omemo_encrypt/rachet/message_key.dart';
import 'package:lib_omemo_encrypt/sessions/session.dart';
import 'package:lib_omemo_encrypt/sessions/session_state.dart';
import 'package:tuple/tuple.dart';

abstract class SessionCipherInterface {
  Future<EncryptedMessage> encryptMessage(Session session, List<int> message);
  decryptPreKeyWhisperMessage(
      Session session, Uint8List omemoExchangeMessageBytes);
  decryptWhisperMessage(Session session, Uint8List omemoExchangeMessageBytes);
  Future<Tuple2<SessionState, Uint8List>?>
      decryptWhisperMessageWithSessionState(
          SessionState sessionState, Uint8List omemoExchangeMessageBytes);
  Future<bool> isValidMac(
      Uint8List data,
      Uint8List macKey,
      int messageVersion,
      SimpleKeyPair senderIdentityKey,
      SimpleKeyPair receiverIdentityKey,
      Uint8List theirMac);
  Future<List<int>> getMac(Uint8List data, Uint8List macKey, int messageVersion,
      SimpleKeyPair senderIdentityKey, SimpleKeyPair receiverIdentityKey);
  Future<Uint8List> createWhisperMessage(
      Session session, Uint8List paddedMessage);
  Future<Uint8List> createPreKeyWhisperMessage(
      Session session, Uint8List whisperMessage);
  Future<Tuple2<SessionState, Chain>> getOrCreateReceivingChain(
      SessionState sessionState, SimplePublicKey theirEphemeralPublicKey);
  Future<MessageKey> getOrCreateMessageKeys(Chain chain, int counter);
  Future<Tuple2<SessionState, Chain>> clickMainRatchet(
      SessionState sessionState, SimplePublicKey theirEphemeralPublicKey);
}
