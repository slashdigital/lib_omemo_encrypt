import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/sessions/session.dart';
import 'package:lib_omemo_encrypt/keys/signed_prekey.dart';
import 'package:lib_omemo_encrypt/keys/prekey.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';
import 'package:lib_omemo_encrypt/storage/storage_interface.dart';
import 'package:tuple/tuple.dart';

class MemoryStorage extends StorageInterface {
  final String localRegistrationId;
  final SimpleKeyPair localIdentityKeyPair;
  late Iterable<Tuple2<int, PreKey>> localPreKeyPairs;
  late List<Tuple2<int, SignedPreKey>> localSignedPreKeyPairs = [];
  late PreKeyBundle remotePreKeyBundle;

  MemoryStorage(
      {required this.localRegistrationId, required this.localIdentityKeyPair})
      : super();

  Tuple2<int, dynamic>? _findExistingById(
      Iterable<Tuple2<int, dynamic>> list, int id) {
    final items = list.where((element) => element.item1 == id);
    return items.isNotEmpty ? items.first : null;
  }

  @override
  Future<String> getLocalRegistrationId() async {
    return localRegistrationId;
  }

  @override
  SimpleKeyPair getLocalIdentityKeyPair() {
    return localIdentityKeyPair;
  }

  @override
  PreKey getLocalPreKeyPair(int preKeyId) =>
      _findExistingById(localPreKeyPairs, preKeyId)!.item2;

  @override
  SignedPreKey getLocalSignedPreKeyPair(int signedPreKeyId) =>
      _findExistingById(localSignedPreKeyPairs, signedPreKeyId)!.item2;

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

  @override
  setLocalPreKeyPair(List<PreKey> prekeys) {
    localPreKeyPairs = prekeys.map<Tuple2<int, PreKey>>((e) => Tuple2(e.id, e));
  }

  @override
  void addLocalSignedPreKeyPair(SignedPreKey signedPreKey) {
    final existing = _findExistingById(localSignedPreKeyPairs, signedPreKey.id);
    if (existing == null) {
      localSignedPreKeyPairs
          .add(Tuple2<int, SignedPreKey>(signedPreKey.id, signedPreKey));
    }
  }
}
