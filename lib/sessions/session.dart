import 'package:lib_omemo_encrypt/sessions/session_interface.dart';
import 'package:lib_omemo_encrypt/sessions/session_state.dart';

class Session extends SessionInterface {
  final List<SessionState> states = [];

  clone(List<SessionState> _session) {
    for (var element in _session) {
      states.add(element);
    }
  }

  @override
  SessionState mostRecentState() {
    return states[0];
  }

  @override
  addState(SessionState sessionState) {
    states.insert(0, sessionState);
    if (states.length > maximumSessionStatesPerIdentity) {
      // states.removeAt(0); // remove last ?
      states.removeLast();
    }
  }

  @override
  removeState(SessionState sessionState) {
    var index = states.indexOf(sessionState);
    states.removeAt(index);
  }
}
