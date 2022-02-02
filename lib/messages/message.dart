import 'dart:convert';
import 'dart:typed_data';
import 'package:lib_omemo_encrypt/messages/omemo_message.dart';
import 'package:lib_omemo_encrypt/rachet/rachet.dart';
import 'package:lib_omemo_encrypt/utils/array_buffer_utils.dart';
import 'package:tuple/tuple.dart';
import 'package:lib_omemo_encrypt/messages/message_interface.dart';
import 'package:lib_omemo_encrypt/protobuf/OMEMOKeyExchange.pb.dart'
    as omemo_proto;
import 'package:lib_omemo_encrypt/protobuf/OMEMOAuthenticatedMessage.pb.dart'
    as omemo_auth_message_proto;
import 'package:lib_omemo_encrypt/protobuf/OMEMOMessage.pb.dart'
    as omemo_message_proto;

class MessageVersion {
  final int current;
  final int max;

  MessageVersion(this.current, this.max);
}

class PreKeyWhisperMessage {
  final omemo_proto.OMEMOKeyExchange message;
  final MessageVersion version;

  PreKeyWhisperMessage({required this.message, required this.version});
}

class WhisperMessage {
  final omemo_message_proto.OMEMOMessage message;
  final MessageVersion version;
  final Uint8List mac;

  WhisperMessage(
      {required this.message, required this.version, required this.mac});
}

class Message extends MessageInterface {
  static Message? _message;
  static Message get message {
    _message ??= Message();
    return _message!;
  }

// Current, Max
  MessageVersion _extractMessageVersion(Uint8List versionByte) {
    var view = Uint8List.fromList(versionByte);
    return MessageVersion((view[0] >> 4) & 0xf, view[0] & 0xf);
  }

  ByteBuffer _getVersionField(MessageVersion version) =>
      ArrayBufferUtils.fromByte((version.current << 4 | version.max) & 0xff);

  @override
  PreKeyWhisperMessage decodePreKeyWhisperMessage(Uint8List listBytes) {
    final message =
        omemo_proto.OMEMOKeyExchange.fromBuffer(listBytes.sublist(1));
    return PreKeyWhisperMessage(
        message: message,
        version: _extractMessageVersion(listBytes.sublist(0, 1)));
  }

  @override
  WhisperMessage decodeWhisperMessage(Uint8List listBytes) {
    final messageBytes = listBytes.sublist(1, listBytes.length - macByteCount);
    final message = omemo_message_proto.OMEMOMessage.fromBuffer(messageBytes);
    return WhisperMessage(
        version: _extractMessageVersion(listBytes.sublist(0, 1)),
        message: message,
        mac: listBytes.sublist(listBytes.length - macByteCount));
  }

  @override
  Uint8List decodeWhisperMessageMacInput(Uint8List listBytes) {
    return listBytes.sublist(0, listBytes.length - macByteCount);
  }

  @override
  encodePreKeyWhisperMessage(
      MessageVersion version, KeyExchangeMessage keyExchangeMessage) async {
    var messageBytes = omemo_proto.OMEMOKeyExchange(
            ek: keyExchangeMessage.baseKey.bytes,
            ik: keyExchangeMessage.identityKey.bytes,
            registrationId: base64Url.decode(keyExchangeMessage.registrationId),
            pkId: keyExchangeMessage.preKeyId,
            spkId: keyExchangeMessage.signedPreKeyId,
            message: keyExchangeMessage.message)
        .writeToBuffer()
        .buffer;
    var versionField = _getVersionField(version);
    return ArrayBufferUtils.concat([versionField, messageBytes]);
  }

  @override
  Uint8List encodeWhisperMessage(
      MessageVersion version, OmemoMessage message, Uint8List mac) {
    return ArrayBufferUtils.concat(
        [encodeWhisperMessageMacInput(version, message).buffer, mac.buffer]);
  }

  @override
  Uint8List encodeWhisperMessageMacInput(
      MessageVersion version, OmemoMessage message) {
    final versionByte = _getVersionField(version);
    final messageBytes = omemo_message_proto.OMEMOMessage(
            n: message.counter,
            pn: message.previousCounter,
            dhPub: message.ratchetKey.bytes,
            ciphertext:
                message.ciphertext.concatenation(nonce: true, mac: true))
        .writeToBuffer()
        .buffer;
    return ArrayBufferUtils.concat([versionByte, messageBytes]);
  }
}
