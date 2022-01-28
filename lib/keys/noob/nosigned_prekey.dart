import 'package:lib_omemo_encrypt/keys/noob/nokey_pair.dart';
import 'package:lib_omemo_encrypt/keys/noob/nosignature.dart';
import 'package:lib_omemo_encrypt/keys/signed_prekey.dart';

class NoSignedPreKey extends SignedPreKey {
  NoSignedPreKey()
      : super(id: -1, keyPair: NoKeyPair(), signature: NoSignature());
}
