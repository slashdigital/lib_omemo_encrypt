import 'dart:typed_data';
import 'package:lib_omemo_encrypt/protobuf/LocalStorage.pb.dart' as local_proto;
import 'package:lib_omemo_encrypt/serialization/serialization_interface.dart';

class MessageKey
    implements Serializable<MessageKey, local_proto.LocalMessageKey> {
  late Uint8List cipherKey;
  late Uint8List macKey;
  late Uint8List iv;
  late int index;

  MessageKey();

  MessageKey.create(
      {required this.cipherKey,
      required this.macKey,
      required this.iv,
      required this.index});

  @override
  Future<MessageKey> deserialize(Uint8List bytes) async {
    final proto = local_proto.LocalMessageKey.fromBuffer(bytes);
    return MessageKey.create(
        cipherKey: Uint8List.fromList(proto.cipherKey),
        macKey: Uint8List.fromList(proto.macKey),
        iv: Uint8List.fromList(proto.iv),
        index: proto.index);
  }

  @override
  Future<Uint8List> serialize() async {
    return (await serializeToProto()).writeToBuffer();
  }

  @override
  Future<local_proto.LocalMessageKey> serializeToProto() async {
    return local_proto.LocalMessageKey(
        cipherKey: cipherKey, iv: iv, macKey: macKey, index: index);
  }
}
