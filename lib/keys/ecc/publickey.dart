import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/keys/ecc/key.dart';
import 'package:lib_omemo_encrypt/serialization/serialization_interface.dart';

import 'package:lib_omemo_encrypt/protobuf/LocalStorage.pb.dart' as local_proto;
import 'package:lib_omemo_encrypt/utils/utils.dart';

class ECDHPublicKey extends ECDHKey implements Serializable<ECDHPublicKey> {
  SimplePublicKey? _publicKey;

  Future<SimplePublicKey> get key async => _publicKey!;

  ECDHPublicKey(this._publicKey);

  @override
  Future<Uint8List> get bytes async => Uint8List.fromList(_publicKey!.bytes);

  static ECDHPublicKey fromBytes(List<int> bytes) {
    return ECDHPublicKey(SimplePublicKey(bytes, type: KeyPairType.x25519));
  }

  @override
  Future<ECDHPublicKey> deserialize(Uint8List bytes) async {
    final localKeyPair = local_proto.LocalPublicKey.fromBuffer(bytes);
    final keyPairType = Utils.keyPairTypeFromName(
        Utils.convertBytesToString(localKeyPair.keyType));
    _publicKey = SimplePublicKey(localKeyPair.publicKey, type: keyPairType);
    return this;
  }

  @override
  Future<Uint8List> serialize() async {
    final data = _publicKey!.bytes;
    final keyType = Utils.convertStringToBytes(_publicKey!.type.name);
    return local_proto.LocalPublicKey(keyType: keyType, publicKey: data)
        .writeToBuffer()
        .buffer
        .asUint8List();
  }
}
