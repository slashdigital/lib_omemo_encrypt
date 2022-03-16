import 'package:lib_omemo_encrypt/keys/whisper/identity_keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';
import 'package:lib_omemo_encrypt/sessions/session.dart';

abstract class StorageInterface {
  initKeys();
  Future<IdentityKeyPair> getLocalIdentityKeyPair();
  Future<String> getLocalRegistrationId();
  Future<void> addLocalSignedPreKeyPair(SignedPreKeyPair signedPreKey);
  Future<SignedPreKeyPair> getLocalSignedPreKeyPair(int signedPreKeyId);
  Future<PreKeyPair> getLocalPreKeyPair(int preKeyId);
  Future<void> setLocalPreKeyPair(List<PreKeyPair> prekeys);
  Future<bool> isRemoteIdentityTrusted();
  Future<bool> hasSession(
      {required bool isGroup,
      required String groupJabberId,
      required String buddyJid});
  Future<dynamic> getSession(
      {required bool isGroup,
      required String groupJabberId,
      required String buddyJid,
      required String deviceId});
  Future<List<dynamic>> getSessions(
      {required bool isGroup,
      required String groupJabberId,
      required String buddyJid});
  Future<dynamic> putSession(
      {required Session session,
      required bool isGroup,
      required String buddyJid, // Required to have buddyJid
      required String deviceId, // Required to have deviceId with buddyJid
      required String groupJabberId, // can be '' if not group
      required Iterable<String> participants});

  const StorageInterface();
}
