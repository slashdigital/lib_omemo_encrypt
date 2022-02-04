import 'package:lib_omemo_encrypt/keys/ecc/key.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';

import 'package:lib_omemo_encrypt/keys/whisper/whisper_key.dart';

class SignedPreKey extends WhisperKey {
  final ECDHKeyPair _key;
  final int signedPreKeyId;
  final WhisperKeyType _keyType = WhisperKeyType.signedPreKey;

  ECDHKeyPair get keyPair => _key;

  const SignedPreKey({required key, required this.signedPreKeyId}) : _key = key;

  @override
  WhisperKeyType get keyType => _keyType;

  @override
  Type get type => _key.runtimeType;
}
