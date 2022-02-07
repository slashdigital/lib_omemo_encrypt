import 'package:lib_omemo_encrypt/encryptions/cipher_session/group/group_key_record.dart';
import 'package:lib_omemo_encrypt/sessions/session_group.dart';

abstract class GroupStorageInterface {
  Future<SenderKeyRecord> loadSessionGroupKey(SessionGroup sessionGroupSender);
  Future<void> storeSessionGroupKey(
      SessionGroup sessionGroupSender, SenderKeyRecord record);
}
