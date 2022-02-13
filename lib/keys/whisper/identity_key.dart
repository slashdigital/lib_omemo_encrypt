import 'dart:typed_data';

import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';

import 'package:lib_omemo_encrypt/keys/whisper/whisper_key.dart';
import 'package:lib_omemo_encrypt/protobuf/LocalStorage.pb.dart' as local_proto;
import 'package:lib_omemo_encrypt/serialization/serialization_interface.dart';

class IdentityKey extends WhisperKey
    implements Serializable<IdentityKey, local_proto.LocalPublicKey> {
  late ECDHPublicKey _key;
  final WhisperKeyType _keyType = WhisperKeyType.identityKey;

  ECDHPublicKey get key => _key;

  IdentityKey();
  IdentityKey.create({
    required ECDHPublicKey key,
  }) : _key = key;

  @override
  WhisperKeyType get keyType => _keyType;

  @override
  Type get type => _key.runtimeType;

  //Feels super wierd that this one is not static :|
  @override
  Future<IdentityKey> deserialize(Uint8List bytes) async {
    final key = await ECDHPublicKey().deserialize(bytes);
    return IdentityKey.create(key: key);
  }

  @override
  Future<Uint8List> serialize() async {
    return await _key.serialize();
  }

  @override
  Future<local_proto.LocalPublicKey> serializeToProto() async {
    return await _key.serializeToProto();
  }
}
