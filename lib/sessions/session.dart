import 'dart:typed_data';

import 'package:lib_omemo_encrypt/serialization/serialization_interface.dart';
import 'package:lib_omemo_encrypt/sessions/session_interface.dart';
import 'package:lib_omemo_encrypt/sessions/session_messaging.dart';
import 'package:lib_omemo_encrypt/sessions/session_state.dart';
import 'package:lib_omemo_encrypt/protobuf/LocalStorage.pb.dart' as local_proto;

/// Session class
/// Contain:
/// - sessionMessagingIdentifie: identifer is it for a person or a group or which device
/// - states: list of state per identity
/// You should implemen to store one by one different identity in your local storage
class Session extends SessionInterface
    implements Serializable<Session, local_proto.LocalSession> {
  late SessionMessaging sessionMessagingIdentity;
  late List<SessionState> states = [];

  Session();
  Session.create(this.sessionMessagingIdentity, {this.states = const []});

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

  @override
  Future<Session> deserialize(Uint8List bytes) async {
    final proto = local_proto.LocalSession.fromBuffer(bytes);
    List<SessionState> mappedSessionState = [];
    for (var state in proto.sessionStates) {
      mappedSessionState
          .add(await SessionState().deserialize(state.writeToBuffer()));
    }
    return Session.create(
        await SessionMessaging()
            .deserialize(proto.sessionMessaging.writeToBuffer()),
        states: mappedSessionState);
  }

  @override
  Future<Uint8List> serialize() async {
    return (await serializeToProto()).writeToBuffer();
  }

  @override
  Future<local_proto.LocalSession> serializeToProto() async {
    List<local_proto.LocalSessionState> mappedSessionState = [];
    for (var state in states) {
      mappedSessionState.add(await state.serializeToProto());
    }
    return local_proto.LocalSession(
        sessionMessaging: await sessionMessagingIdentity.serializeToProto(),
        sessionStates: mappedSessionState);
  }
}
