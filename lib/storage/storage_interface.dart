import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';
import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';

abstract class StorageInterface {
  initKeys();
  SimpleKeyPair getLocalIdentityKeyPair();
  Future<String> getLocalRegistrationId();

  SignedPreKey getLocalSignedPreKeyPair();
  PreKey getLocalPreKeyPair();
  PreKeyBundle getRemotePreKeyBundle();
  bool isRemoteIdentityTrusted();
  bool hasSession();
  Session getSession();
  Session putSession();

  const StorageInterface();
}
