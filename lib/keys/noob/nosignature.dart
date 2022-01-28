import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/keys/noob/nokey_pair.dart';
import 'package:lib_omemo_encrypt/keys/noob/nopublickey.dart';

class NoSignature extends Signature {
  NoSignature() : super([], publicKey: NoPublicKey());
}
