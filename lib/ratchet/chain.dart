import 'dart:typed_data';

import 'package:lib_omemo_encrypt/ratchet/message_key.dart';
import 'package:lib_omemo_encrypt/protobuf/LocalStorage.pb.dart' as local_proto;
import 'package:lib_omemo_encrypt/serialization/serialization_interface.dart';

class Chain implements Serializable<Chain, local_proto.LocalChain> {
  late Uint8List key;
  late int index = 0;
  List<MessageKey?> messageKeys = [];

  Chain();
  Chain.create(this.key, {this.index = 0, List<MessageKey?>? messageKeysList}) {
    if (messageKeysList != null) {
      messageKeys = messageKeysList;
    }
  }

  Chain copyWith({int? index, Uint8List? key, List<MessageKey?>? messageKeys}) {
    final _chain = Chain.create(this.key, index: index ?? this.index);
    _chain.messageKeys = messageKeys ?? this.messageKeys;
    return _chain;
  }

  @override
  Future<Chain> deserialize(Uint8List bytes) async {
    final proto = local_proto.LocalChain.fromBuffer(bytes);
    final List<MessageKey> parsedMappedList = [];
    for (var messageKey in proto.messageKeys) {
      parsedMappedList
          .add(await MessageKey().deserialize(messageKey.writeToBuffer()));
    }
    return Chain.create(Uint8List.fromList(proto.key),
        index: proto.index, messageKeysList: parsedMappedList);
  }

  @override
  Future<Uint8List> serialize() async {
    return (await serializeToProto()).writeToBuffer();
  }

  @override
  Future<local_proto.LocalChain> serializeToProto() async {
    final mappedList = [];
    for (var messageKey in messageKeys) {
      mappedList.add(await messageKey!.serializeToProto());
    }
    return local_proto.LocalChain(
        key: key, index: index, messageKeys: mappedList.map((e) => e));
  }
}
