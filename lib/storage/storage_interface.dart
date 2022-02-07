import 'package:lib_omemo_encrypt/keys/whisper/identity_keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';
import 'package:lib_omemo_encrypt/sessions/session.dart';

abstract class StorageInterface {
  initKeys();
  IdentityKeyPair getLocalIdentityKeyPair();
  Future<String> getLocalRegistrationId();
  void addLocalSignedPreKeyPair(SignedPreKeyPair signedPreKey);
  SignedPreKeyPair getLocalSignedPreKeyPair(int signedPreKeyId);
  PreKeyPair getLocalPreKeyPair(int preKeyId);
  void setLocalPreKeyPair(List<PreKeyPair> prekeys);
  bool isRemoteIdentityTrusted();
  bool hasSession();
  Session getSession();
  Session putSession(Session session);

  const StorageInterface();
}
