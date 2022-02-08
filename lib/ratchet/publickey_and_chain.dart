import 'dart:typed_data';

import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';
import 'package:lib_omemo_encrypt/ratchet/chain.dart';
import 'package:lib_omemo_encrypt/protobuf/LocalStorage.pb.dart' as local_proto;
import 'package:lib_omemo_encrypt/serialization/serialization_interface.dart';

class PublicKeyAndChain
    implements
        Serializable<PublicKeyAndChain, local_proto.LocalPublicKeyAndChain> {
  late ECDHPublicKey ephemeralPublicKey;
  late Chain chain;

  PublicKeyAndChain();
  PublicKeyAndChain.create(
      {required this.ephemeralPublicKey, required this.chain});

  @override
  Future<PublicKeyAndChain> deserialize(Uint8List bytes) async {
    final proto = local_proto.LocalPublicKeyAndChain.fromBuffer(bytes);
    final _publicKey = await ECDHPublicKey()
        .deserialize(Uint8List.fromList(proto.ephemeralPublicKey));
    final _chain = await Chain().deserialize(proto.chain.writeToBuffer());
    return PublicKeyAndChain.create(
        ephemeralPublicKey: _publicKey, chain: _chain);
  }

  @override
  Future<Uint8List> serialize() async {
    return (await serializeToProto()).writeToBuffer();
  }

  @override
  Future<local_proto.LocalPublicKeyAndChain> serializeToProto() async {
    return local_proto.LocalPublicKeyAndChain(
        chain: await chain.serializeToProto(),
        ephemeralPublicKey: await ephemeralPublicKey.serialize());
  }
}
