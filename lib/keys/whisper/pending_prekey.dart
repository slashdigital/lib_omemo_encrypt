import 'dart:typed_data';

import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';

import 'package:lib_omemo_encrypt/keys/whisper/whisper_key.dart';
import 'package:lib_omemo_encrypt/protobuf/LocalStorage.pb.dart' as local_proto;
import 'package:lib_omemo_encrypt/serialization/serialization_interface.dart';

class PendingPreKey extends WhisperKey
    implements Serializable<PendingPreKey, local_proto.LocalPendingPreKey> {
  late int preKeyId;

  late ECDHPublicKey _key;
  late int signedPreKeyId;
  final WhisperKeyType _keyType = WhisperKeyType.pendingPreKey;

  ECDHPublicKey get publicKey => _key;

  PendingPreKey();

  PendingPreKey.create(
      {required this.preKeyId,
      required ECDHPublicKey key,
      required this.signedPreKeyId})
      : _key = key;

  @override
  WhisperKeyType get keyType => _keyType;

  @override
  Type get type => _key.runtimeType;

  @override
  Future<PendingPreKey> deserialize(Uint8List bytes) async {
    final proto = local_proto.LocalPendingPreKey.fromBuffer(bytes);
    return PendingPreKey.create(
        preKeyId: proto.preKeyId,
        key: await ECDHPublicKey().deserialize(proto.publicKey.writeToBuffer()),
        signedPreKeyId: proto.signedPreKeyId);
  }

  @override
  Future<Uint8List> serialize() async {
    return (await serializeToProto()).writeToBuffer();
  }

  @override
  Future<local_proto.LocalPendingPreKey> serializeToProto() async {
    return local_proto.LocalPendingPreKey(
        preKeyId: preKeyId,
        signedPreKeyId: signedPreKeyId,
        publicKey: await publicKey.serializeToProto());
  }
}
