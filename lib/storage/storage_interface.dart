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
  Future<bool> hasSession();
  Future<Session> getSession();
  Future<Session> putSession(Session session);

  const StorageInterface();
}
