import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/keys/ecc/key.dart';
import 'package:lib_omemo_encrypt/serialization/serialization_interface.dart';

import 'package:lib_omemo_encrypt/protobuf/LocalStorage.pb.dart' as local_proto;
import 'package:lib_omemo_encrypt/utils/utils.dart';

class ECDHPublicKey extends ECDHKey
    implements Serializable<ECDHPublicKey, local_proto.LocalPublicKey> {
  late SimplePublicKey _publicKey;

  Future<SimplePublicKey> get key async => _publicKey;

  ECDHPublicKey();
  ECDHPublicKey.create(this._publicKey);

  @override
  Future<Uint8List> get bytes async => Uint8List.fromList(_publicKey.bytes);

  static ECDHPublicKey fromBytes(List<int> bytes) {
    return ECDHPublicKey.create(
        SimplePublicKey(bytes, type: KeyPairType.x25519));
  }

  @override
  Future<ECDHPublicKey> deserialize(Uint8List bytes) async {
    final localKeyPair = local_proto.LocalPublicKey.fromBuffer(bytes);
    final keyPairType = Utils.keyPairTypeFromName(
        Utils.convertBytesToString(localKeyPair.keyType));
    return ECDHPublicKey.create(
        SimplePublicKey(localKeyPair.publicKey, type: keyPairType));
  }

  @override
  Future<Uint8List> serialize() async {
    return (await serializeToProto()).writeToBuffer().buffer.asUint8List();
  }

  @override
  Future<local_proto.LocalPublicKey> serializeToProto() async {
    final data = _publicKey.bytes;
    final keyType = Utils.convertStringToBytes(_publicKey.type.name);
    return local_proto.LocalPublicKey(keyType: keyType, publicKey: data);
  }
}
