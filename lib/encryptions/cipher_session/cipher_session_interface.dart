import 'package:lib_omemo_encrypt/encryptions/cipher_session/cipher_session_params.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';
import 'package:lib_omemo_encrypt/sessions/session_state.dart';

abstract class CipherSessionInterface {
  createSessionFromPreKeyBundle(PreKeyBundle receivingPreKeyBundle);
  Future<SessionState> initializeAliceSession(
      CipherSessionParams aliceParameters);
}
