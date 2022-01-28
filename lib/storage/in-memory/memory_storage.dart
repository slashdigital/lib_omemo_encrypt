import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/sessions/session.dart';
import 'package:lib_omemo_encrypt/keys/signed_prekey.dart';
import 'package:lib_omemo_encrypt/keys/prekey.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';
import 'package:lib_omemo_encrypt/storage/storage_interface.dart';

class MemoryStorage extends StorageInterface {
  final String localRegistrationId;
  final SimpleKeyPair localIdentityKeyPair;
  final PreKey localPreKeyPair;
  final SignedPreKey localSignedPreKeyPair;
  final PreKeyBundle remotePreKeyBundle;

  const MemoryStorage(
      {required this.localRegistrationId,
      required this.localIdentityKeyPair,
      required this.localPreKeyPair,
      required this.localSignedPreKeyPair,
      required this.remotePreKeyBundle})
      : super();
  @override
  Future<String> getLocalRegistrationId() async {
    return localRegistrationId;
  }

  @override
  SimpleKeyPair getLocalIdentityKeyPair() {
    return localIdentityKeyPair;
  }

  @override
  PreKey getLocalPreKeyPair() => localPreKeyPair;

  @override
  SignedPreKey getLocalSignedPreKeyPair() => localSignedPreKeyPair;

  @override
  PreKeyBundle getRemotePreKeyBundle() => remotePreKeyBundle;

  @override
  Session getSession() {
    // TODO: implement getSession
    throw UnimplementedError();
  }

  @override
  bool hasSession() {
    // TODO: implement hasSession
    throw UnimplementedError();
  }

  @override
  initKeys() {
    // TODO: implement initKeys
    throw UnimplementedError();
  }

  @override
  bool isRemoteIdentityTrusted() {
    // TODO: implement isRemoteIdentityTrusted
    throw UnimplementedError();
  }

  @override
  Session putSession() {
    // TODO: implement putSession
    throw UnimplementedError();
  }
}
