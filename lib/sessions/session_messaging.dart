import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:lib_omemo_encrypt/serialization/serialization_interface.dart';
import 'package:lib_omemo_encrypt/sessions/session_group.dart';
import 'package:lib_omemo_encrypt/sessions/session_user.dart';
import 'package:lib_omemo_encrypt/protobuf/LocalStorage.pb.dart' as local_proto;

enum SessionChatType { personalChat, groupChat }

/// Class SessionMessaging
///
/// Further implementation to the chat application, need to serialize and deserialize back
/// the stored session, user/group relative to that session plus your own devices and your friend device.
/// Imagine in hive, you would have store maybe
/// - user_id
/// - group_id (nullable)
/// - type (personal or group)
/// - device_id
/// - is_your_own
/// - group_name
/// - user_name
/// - sessions []
/// - session[].state
/// - session[].state.sessionVersion
/// - session[].state.remoteIdentityKey (public key)
/// - session[].state.localIdentityKey (public key)
/// - session[].state.localRegistrationId (string)
/// - session[].state.rootKey (bytes)
/// - session[].state.sendingChain (object)
/// - session[].state.sendingChain.key (bytes)
/// - session[].state.sendingChain.index (int)
/// - session[].state.sendingChain.messageKeys[] (object)
/// - session[].state.sendingChain.messageKeys[].cipherKey (bytes)
/// - session[].state.sendingChain.messageKeys[].macKey (bytes)
/// - session[].state.sendingChain.messageKeys[].iv (bytes)
/// - session[].state.senderRatchetKeyPair (private key/key pair)
/// - session[].state.receivingChains[]
/// - session[].state.receivingChains[].ephemeralPublicKey (public key)
/// - session[].state.receivingChains[].chain (object)
/// - session[].state.receivingChains[].chain.key (bytes)
/// - session[].state.receivingChains[].chain.index (int)
/// - session[].state.receivingChains[].chain.messageKeys[] (object)
/// - session[].state.receivingChains[].chain.messageKeys[].cipherKey (bytes)
/// - session[].state.receivingChains[].chain.messageKeys[].macKey (bytes)
/// - session[].state.receivingChains[].chain.messageKeys[].iv (bytes)
/// - session[].state.previousCounter (int)
/// - session[].state.pending (pending prekey - object)
/// - session[].state.pending.preKeyId (int)
/// - session[].state.pending._key (public key)
/// - session[].state.pending._keyType (enum)
/// - session[].state.pending.signedPreKeyId (int)
/// - session[].state.theirBaseKey (public key)
class SessionMessaging extends Equatable
    implements
        Serializable<SessionMessaging, local_proto.LocalSessionMessaging>,
        Comparable {
  late SessionUser sessionUser;
  late SessionGroup? sessionGroup;
  late SessionChatType sessionChatType;

  SessionMessaging();
  SessionMessaging.create(
      {required this.sessionUser,
      required this.sessionGroup,
      required this.sessionChatType});

  ///
  /// Supposed you fetch a devices of the your peer including your device,
  /// So you need init single SessionMessage for each peer's devices plus your own devices as well.
  static SessionMessaging createPersonalSessionIdentifier({
    required String friendName,
    required String friendDeviceId,
  }) {
    return SessionMessaging.create(
        sessionUser: SessionUser(name: friendName, deviceId: friendDeviceId),
        sessionGroup: null,
        sessionChatType: SessionChatType.personalChat);
  }

  ///
  /// Supposed you fetch a devices of the group members including your devices
  /// So you need init single SessionMessage for each members x devices plus your own devices as well.
  static SessionMessaging createGroupSessionIdentifier({
    required String
        friendInGroupName, // Each of every friend in group including your other devices
    required String friendInGroupDeviceId,
    required String groupName,
    required String groupId,
  }) {
    final _sessionUser =
        SessionUser(name: friendInGroupName, deviceId: friendInGroupDeviceId);
    return SessionMessaging.create(
        sessionUser: _sessionUser,
        sessionGroup: SessionGroup(
            groupName: groupName, groupId: groupId, sender: _sessionUser),
        sessionChatType: SessionChatType.groupChat);
  }

  @override
  List<Object?> get props => [sessionUser, sessionGroup, sessionChatType];

  @override
  Future<SessionMessaging> deserialize(Uint8List bytes) async {
    final proto = local_proto.LocalSessionMessaging.fromBuffer(bytes);
    final _sessionChatType = proto.isGroup
        ? SessionChatType.groupChat
        : SessionChatType.personalChat;
    SessionGroup? _sessionGroup;
    if (proto.isGroup) {
      _sessionGroup = SessionGroup(
          groupName: proto.groupName,
          groupId: proto.groupId,
          sender: SessionUser(
              name: proto.groupSenderName,
              deviceId: proto.groupSenderDeviceId));
    }
    SessionUser _sessionUser =
        SessionUser(name: proto.userName, deviceId: proto.userDeviceId);
    return SessionMessaging.create(
        sessionUser: _sessionUser,
        sessionGroup: _sessionGroup,
        sessionChatType: _sessionChatType);
  }

  @override
  Future<Uint8List> serialize() async {
    return (await serializeToProto()).writeToBuffer();
  }

  @override
  Future<local_proto.LocalSessionMessaging> serializeToProto() async {
    final groupId = sessionGroup != null ? sessionGroup!.groupId : '';
    final groupName = sessionGroup != null ? sessionGroup!.groupName : '';
    final groupSenderName =
        sessionGroup != null ? sessionGroup!.sender.name : '';
    final groupSenderDeviceId =
        sessionGroup != null ? sessionGroup!.sender.deviceId : '';
    return local_proto.LocalSessionMessaging(
        groupId: groupId,
        groupName: groupName,
        groupSenderDeviceId: groupSenderDeviceId,
        groupSenderName: groupSenderName,
        userName: sessionUser.name,
        userDeviceId: sessionUser.deviceId,
        isGroup: sessionChatType == SessionChatType.groupChat);
  }

  @override
  int compareTo(other) {
    final ourContent =
        '${sessionUser.toString()}-${sessionGroup != null ? sessionGroup.toString() : 'N/A'}';
    final otherContent =
        '${other.sessionUser.toString()}-${other.sessionGroup != null ? other.sessionGroup.toString() : 'N/A'}';
    return ourContent.compareTo(otherContent);
  }
}
