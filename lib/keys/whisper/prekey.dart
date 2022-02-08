import 'dart:typed_data';

import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';

import 'package:lib_omemo_encrypt/keys/whisper/whisper_key.dart';
import 'package:lib_omemo_encrypt/serialization/serialization_interface.dart';
import 'package:lib_omemo_encrypt/protobuf/LocalStorage.pb.dart' as local_proto;

class PreKeyPair extends WhisperKey
    implements Serializable<PreKeyPair, local_proto.LocalPreKeyPair> {
  late int preKeyId;
  late ECDHKeyPair _key;
  final WhisperKeyType _keyType = WhisperKeyType.preKeyPair;

  ECDHKeyPair get keyPair => _key;

  PreKeyPair();
  PreKeyPair.create({required this.preKeyId, required key}) {
    _key = key;
  }

  @override
  WhisperKeyType get keyType => _keyType;

  @override
  Type get type => _key.runtimeType;

  Future<PreKey> get preKey async =>
      PreKey.create(preKeyId, await keyPair.publicKey);

  @override
  Future<PreKeyPair> deserialize(Uint8List bytes) async {
    final proto = local_proto.LocalPreKeyPair.fromBuffer(bytes);
    return PreKeyPair.create(
        preKeyId: proto.preKeyId,
        key: await ECDHKeyPair().deserialize(proto.keyPair.writeToBuffer()));
  }

  @override
  Future<Uint8List> serialize() async {
    return (await serializeToProto()).writeToBuffer();
  }

  @override
  Future<local_proto.LocalPreKeyPair> serializeToProto() async {
    final proto = local_proto.LocalPreKeyPair(
        keyPair: await _key.serializeToProto(), preKeyId: preKeyId);
    return proto;
  }
}

class PreKey extends WhisperKey
    implements Serializable<PreKey, local_proto.LocalPreKey> {
  late int preKeyId;
  late ECDHPublicKey _key;
  final WhisperKeyType _keyType = WhisperKeyType.preKey;

  ECDHPublicKey get key => _key;

  PreKey();

  PreKey.create(this.preKeyId, key) {
    _key = key;
  }

  @override
  WhisperKeyType get keyType => _keyType;

  @override
  Type get type => _key.runtimeType;

  @override
  Future<PreKey> deserialize(Uint8List bytes) async {
    final proto = local_proto.LocalPreKey.fromBuffer(bytes);
    _key = await ECDHPublicKey().deserialize(proto.publicKey.writeToBuffer());
    preKeyId = proto.preKeyId;
    PreKey().deserialize(bytes);
    return PreKey.create(preKeyId, key);
  }

  @override
  Future<Uint8List> serialize() async {
    return (await serializeToProto()).writeToBuffer();
  }

  @override
  Future<local_proto.LocalPreKey> serializeToProto() async {
    final proto = local_proto.LocalPreKey(
        publicKey: await _key.serializeToProto(), preKeyId: preKeyId);
    return proto;
  }
}
