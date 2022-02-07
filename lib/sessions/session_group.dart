import 'package:lib_omemo_encrypt/sessions/session_user.dart';

class SessionGroup {
  final String groupName;
  final String groupId;
  final SessionUser sender;

  const SessionGroup(
      {required this.groupName, required this.groupId, required this.sender});
  @override
  String toString() {
    return 'Group: $groupName, ID: $groupId, Sender {$sender}';
  }
}
