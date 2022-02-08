import 'package:lib_omemo_encrypt/sessions/session_interface.dart';
import 'package:lib_omemo_encrypt/sessions/session_messaging.dart';
import 'package:lib_omemo_encrypt/sessions/session_state.dart';

/// Session class
/// Contain:
/// - sessionMessagingIdentifie: identifer is it for a person or a group or which device
/// - states: list of state per identity
/// You should implemen to store one by one different identity in your local storage
class Session extends SessionInterface {
  final SessionMessaging sessionMessagingIdentity;
  final List<SessionState> states = [];

  Session(this.sessionMessagingIdentity);

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
