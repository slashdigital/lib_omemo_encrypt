import 'package:lib_omemo_encrypt/keys/ecc/key.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';

import 'package:lib_omemo_encrypt/keys/whisper/whisper_key.dart';

class PendingPreKey extends WhisperKey {
  final int preKeyId;

  final ECDHPublicKey _key;
  final int signedPreKeyId;
  final WhisperKeyType _keyType = WhisperKeyType.pendingPreKey;

  ECDHPublicKey get publicKey => _key;

  const PendingPreKey(
      {required this.preKeyId, required key, required this.signedPreKeyId})
      : _key = key;

  @override
  WhisperKeyType get keyType => _keyType;

  @override
  Type get type => _key.runtimeType;
}
