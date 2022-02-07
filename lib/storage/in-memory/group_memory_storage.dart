import 'package:lib_omemo_encrypt/encryptions/cipher_session/group/group_key_record.dart';
import 'package:lib_omemo_encrypt/sessions/session_group.dart';
import 'package:lib_omemo_encrypt/storage/group_storage_interface.dart';

class GroupMemoryStorage extends GroupStorageInterface {
  Map<SessionGroup, SenderKeyRecord> store = {};
  @override
  Future<SenderKeyRecord> loadSessionGroupKey(
      SessionGroup sessionGroupSender) async {
    try {
      final record = store[sessionGroupSender];
      if (record == null) {
        return SenderKeyRecord();
      } else {
        return SenderKeyRecord.copyWith(record.clone());
      }
    } on Exception catch (e) {
      throw AssertionError(e);
    }
  }

  @override
  storeSessionGroupKey(
      SessionGroup sessionGroupSender, SenderKeyRecord record) async {
    store[sessionGroupSender] = record;
  }
}
