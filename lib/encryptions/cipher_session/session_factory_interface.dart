import 'dart:typed_data';

import 'package:lib_omemo_encrypt/encryptions/cipher_session/alice_cipher_session_params.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/bob_cipher_session_params.dart';
import 'package:lib_omemo_encrypt/keys/bundle/receiving_prekey_bundle.dart';
import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';
import 'package:lib_omemo_encrypt/sessions/session_state.dart';

abstract class SessionFactoryInterface {
  createSessionFromPreKeyBundle(ReceivingPreKeyBundle receivingPreKeyBundle);
  Future<SessionState> initializeAliceSession(
      AliceCipherSessionParams parameters);
  Future<SessionCipherState> createSessionFromPreKeyWhisperMessage(
      Session session, Uint8List preKeyWhisperMessageBytes);
  Future<SessionState> initializeBobSession(BobCipherSessionParams parameters);
}
