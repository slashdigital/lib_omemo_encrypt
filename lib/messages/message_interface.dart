import 'dart:typed_data';

import 'package:lib_omemo_encrypt/messages/message.dart';
import 'package:lib_omemo_encrypt/messages/omemo_message.dart';

abstract class MessageInterface {
  WhisperMessage decodeWhisperMessage(Uint8List listBytes);
  Uint8List decodeWhisperMessageMacInput(Uint8List listBytes);
  Uint8List encodeWhisperMessage(
      MessageVersion version, OmemoMessage message, Uint8List mac);
  Uint8List encodeWhisperMessageMacInput(
      MessageVersion version, OmemoMessage message);
  decodePreKeyWhisperMessage(Uint8List listBytes);
  encodePreKeyWhisperMessage(
      MessageVersion version, KeyExchangeMessage keyExchangeMessage);
}
