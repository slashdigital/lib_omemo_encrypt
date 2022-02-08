import 'dart:typed_data';

import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';
import 'package:lib_omemo_encrypt/protobuf/LocalStorage.pb.dart' as local_proto;

import 'package:lib_omemo_encrypt/keys/whisper/whisper_key.dart';
import 'package:lib_omemo_encrypt/serialization/serialization_interface.dart';

class SignedPreKeyPair extends WhisperKey
    implements
        Serializable<SignedPreKeyPair, local_proto.LocalSignedPreKeyPair> {
  late ECDHKeyPair _key;
  late int signedPreKeyId;
  final WhisperKeyType _keyType = WhisperKeyType.signedPreKeyPair;

  ECDHKeyPair get keyPair => _key;

  SignedPreKeyPair();
  SignedPreKeyPair.create(
      {required ECDHKeyPair key, required this.signedPreKeyId}) {
    _key = key;
  }

  @override
  WhisperKeyType get keyType => _keyType;

  @override
  Type get type => _key.runtimeType;

  Future<SignedPreKey> get signedPreKey async => SignedPreKey.create(
      key: await keyPair.publicKey, signedPreKeyId: signedPreKeyId);

  @override
  Future<SignedPreKeyPair> deserialize(Uint8List bytes) async {
    final proto = local_proto.LocalSignedPreKeyPair.fromBuffer(bytes);
    return SignedPreKeyPair.create(
        key: await ECDHKeyPair().deserialize(proto.keyPair.writeToBuffer()),
        signedPreKeyId: proto.signedPreKeyId);
  }

  @override
  Future<Uint8List> serialize() async {
    return (await serializeToProto()).writeToBuffer();
  }

  @override
  Future<local_proto.LocalSignedPreKeyPair> serializeToProto() async {
    return local_proto.LocalSignedPreKeyPair(
        keyPair: await _key.serializeToProto(), signedPreKeyId: signedPreKeyId);
  }
}

class SignedPreKey extends WhisperKey
    implements Serializable<SignedPreKey, local_proto.LocalSignedPreKey> {
  late ECDHPublicKey _key;
  late int signedPreKeyId;
  final WhisperKeyType _keyType = WhisperKeyType.signedPreKey;

  ECDHPublicKey get key => _key;

  SignedPreKey();
  SignedPreKey.create(
      {required ECDHPublicKey key, required this.signedPreKeyId}) {
    _key = key;
  }

  @override
  WhisperKeyType get keyType => _keyType;

  @override
  Type get type => _key.runtimeType;

  @override
  Future<SignedPreKey> deserialize(Uint8List bytes) async {
    final proto = local_proto.LocalSignedPreKey.fromBuffer(bytes);
    return SignedPreKey.create(
        key: await ECDHPublicKey().deserialize(proto.publicKey.writeToBuffer()),
        signedPreKeyId: proto.signedPreKeyId);
  }

  @override
  Future<Uint8List> serialize() async {
    return (await serializeToProto()).writeToBuffer();
  }

  @override
  Future<local_proto.LocalSignedPreKey> serializeToProto() async {
    return local_proto.LocalSignedPreKey(
        publicKey: await _key.serializeToProto(),
        signedPreKeyId: signedPreKeyId);
  }
}
