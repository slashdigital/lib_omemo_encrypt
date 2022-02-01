import 'package:lib_omemo_encrypt/sessions/session_state.dart';

const maximumSessionStatesPerIdentity = 20;

abstract class SessionInterface {
  SessionState mostRecentState();
  addState(SessionState sessionState);
  removeState(SessionState sessionState);
}
