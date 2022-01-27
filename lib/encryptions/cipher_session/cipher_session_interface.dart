import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';

abstract class CipherSessionInterface {
  createSessionFromPreKeyBundle(PreKeyBundle preKeyBundle);
}
