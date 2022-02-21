import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/keys/ecc/key.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';
import 'package:lib_omemo_encrypt/serialization/serialization_interface.dart';
import 'package:lib_omemo_encrypt/protobuf/LocalStorage.pb.dart' as local_proto;
import 'package:lib_omemo_encrypt/utils/utils.dart';

class ECDHKeyPair extends ECDHKey
    implements Serializable<ECDHKeyPair, local_proto.LocalKeyPair> {
  late SimpleKeyPair _keyPair;
  late SimplePublicKey _publicKey;

  SimpleKeyPair get keyPair => _keyPair;

  bool get hasKeys => true;

  ECDHKeyPair();
  ECDHKeyPair.create(this._keyPair);
  ECDHKeyPair.createPair(this._keyPair, this._publicKey);

  Future<ECDHPublicKey> get publicKey async => ECDHPublicKey.create(_publicKey);

  Future<SimplePublicKey> get key async => await keyPair.extractPublicKey();

  static ECDHKeyPair empty() {
    return ECDHKeyPair();
  }

  @override
  Future<Uint8List> get bytes async =>
      Uint8List.fromList(await keyPair.extractPrivateKeyBytes());

  Future<Uint8List> get publicKeyBytes async =>
      Uint8List.fromList(_publicKey.bytes);

  static Future<ECDHKeyPair> fromBytes(
      List<int> bytes, List<int> publicKeyBytes) async {
    final pubKey = await ECDHPublicKey.fromBytes(publicKeyBytes).key;
    return ECDHKeyPair.createPair(
        SimpleKeyPairData(bytes, type: KeyPairType.x25519, publicKey: pubKey),
        pubKey);
  }

  @override
  Future<ECDHKeyPair> deserialize(Uint8List bytes) async {
    final localKeyPair = local_proto.LocalKeyPair.fromBuffer(bytes);
    final keyPairType = Utils.keyPairTypeFromName(
        Utils.convertBytesToString(localKeyPair.keyType));
    final publicKey =
        SimplePublicKey(localKeyPair.publicKey, type: keyPairType);
    return ECDHKeyPair.createPair(
        SimpleKeyPairData(localKeyPair.privateKey,
            publicKey: publicKey, type: keyPairType),
        publicKey);
  }

  @override
  Future<Uint8List> serialize() async {
    return (await serializeToProto()).writeToBuffer().buffer.asUint8List();
  }

  @override
  Future<local_proto.LocalKeyPair> serializeToProto() async {
    final data = await keyPair.extract();
    final keyType = Utils.convertStringToBytes(data.type.name);
    final publicKey = await data.extractPublicKey();
    return local_proto.LocalKeyPair(
        keyType: keyType,
        privateKey: await data.extractPrivateKeyBytes(),
        publicKey: publicKey.bytes);
  }
}
