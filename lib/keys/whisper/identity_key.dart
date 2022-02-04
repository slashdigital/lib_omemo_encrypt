import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';

import 'package:lib_omemo_encrypt/keys/whisper/whisper_key.dart';

class IdentityKey extends WhisperKey {
  final ECDHPublicKey _key;
  final WhisperKeyType _keyType = WhisperKeyType.identityKey;

  ECDHPublicKey get publicKey => _key;

  const IdentityKey({
    required key,
  }) : _key = key;

  @override
  WhisperKeyType get keyType => _keyType;

  @override
  Type get type => _key.runtimeType;
}
