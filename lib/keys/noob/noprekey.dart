import 'package:lib_omemo_encrypt/keys/noob/nokey_pair.dart';
import 'package:lib_omemo_encrypt/keys/prekey.dart';

class NoPreKey extends PreKey {
  NoPreKey() : super(id: -1, keyPair: NoKeyPair());
}
