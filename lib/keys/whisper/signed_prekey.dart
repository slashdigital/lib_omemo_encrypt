import 'package:lib_omemo_encrypt/keys/ecc/key.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';

import 'package:lib_omemo_encrypt/keys/whisper/whisper_key.dart';

class SignedPreKeyPair extends WhisperKey {
  final ECDHKeyPair _key;
  final int signedPreKeyId;
  final WhisperKeyType _keyType = WhisperKeyType.signedPreKeyPair;

  ECDHKeyPair get keyPair => _key;

  const SignedPreKeyPair({required key, required this.signedPreKeyId})
      : _key = key;

  @override
  WhisperKeyType get keyType => _keyType;

  @override
  Type get type => _key.runtimeType;

  Future<SignedPreKey> get signedPreKey async => SignedPreKey(
      key: await keyPair.publicKey, signedPreKeyId: signedPreKeyId);
}

class SignedPreKey extends WhisperKey {
  final ECDHPublicKey _key;
  final int signedPreKeyId;
  final WhisperKeyType _keyType = WhisperKeyType.signedPreKey;

  ECDHPublicKey get key => _key;

  const SignedPreKey({required ECDHPublicKey key, required this.signedPreKeyId})
      : _key = key;

  @override
  WhisperKeyType get keyType => _keyType;

  @override
  Type get type => _key.runtimeType;
}
