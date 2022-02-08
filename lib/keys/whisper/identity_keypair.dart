import 'dart:typed_data';

import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_key.dart';

import 'package:lib_omemo_encrypt/keys/whisper/whisper_key.dart';
import 'package:lib_omemo_encrypt/protobuf/LocalStorage.pb.dart' as local_proto;
import 'package:lib_omemo_encrypt/serialization/serialization_interface.dart';

class IdentityKeyPair extends WhisperKey
    implements Serializable<IdentityKeyPair, local_proto.LocalKeyPair> {
  late ECDHKeyPair _key;
  final WhisperKeyType _keyType = WhisperKeyType.identityKeyPair;

  ECDHKeyPair get keyPair => _key;
  Future<IdentityKey> get identityKey async =>
      IdentityKey.create(key: await keyPair.publicKey);

  IdentityKeyPair();
  IdentityKeyPair.create({
    required ECDHKeyPair key,
  }) : _key = key;

  @override
  WhisperKeyType get keyType => _keyType;

  @override
  Type get type => _key.runtimeType;

  @override
  Future<IdentityKeyPair> deserialize(Uint8List bytes) async {
    final key = await ECDHKeyPair().deserialize(bytes);
    return IdentityKeyPair.create(key: key);
  }

  @override
  Future<Uint8List> serialize() async {
    return await _key.serialize();
  }

  @override
  Future<local_proto.LocalKeyPair> serializeToProto() async {
    return await _key.serializeToProto();
  }
}
