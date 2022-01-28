import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/keys/key.dart';
import 'package:lib_omemo_encrypt/keys/noob/nokey_pair.dart';

class PendingPreKey extends LibOMEMOKey {
  final int preKeyId;
  final SimplePublicKey baseKey;
  final int signedPreKeyId;

  PendingPreKey(
      {required this.preKeyId,
      required this.baseKey,
      required this.signedPreKeyId})
      : super(id: -1, keyPair: NoKeyPair());
}
