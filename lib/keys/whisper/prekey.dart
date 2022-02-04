import 'package:lib_omemo_encrypt/keys/ecc/key.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';

import 'package:lib_omemo_encrypt/keys/whisper/whisper_key.dart';

class PreKeyPair extends WhisperKey {
  final int preKeyId;
  final ECDHKeyPair _key;
  final WhisperKeyType _keyType = WhisperKeyType.preKeyPair;

  ECDHKeyPair get keyPair => _key;

  const PreKeyPair({required this.preKeyId, required key}) : _key = key;

  @override
  WhisperKeyType get keyType => _keyType;

  @override
  Type get type => _key.runtimeType;
}
