import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_key.dart';

import 'package:lib_omemo_encrypt/keys/whisper/whisper_key.dart';

class IdentityKeyPair extends WhisperKey {
  final ECDHKeyPair _key;
  final WhisperKeyType _keyType = WhisperKeyType.identityKeyPair;

  ECDHKeyPair get keyPair => _key;
  Future<IdentityKey> get identityKey async =>
      IdentityKey(key: await keyPair.publicKey);

  const IdentityKeyPair({
    required ECDHKeyPair key,
  }) : _key = key;

  @override
  WhisperKeyType get keyType => _keyType;

  @override
  Type get type => _key.runtimeType;
}
