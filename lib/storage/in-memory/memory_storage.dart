import 'package:lib_omemo_encrypt/keys/whisper/identity_keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';
import 'package:lib_omemo_encrypt/sessions/session.dart';
import 'package:lib_omemo_encrypt/storage/storage_interface.dart';
import 'package:tuple/tuple.dart';

class MemoryStorage extends StorageInterface {
  final String localRegistrationId;
  final IdentityKeyPair localIdentityKeyPair;
  late Iterable<Tuple2<int, PreKeyPair>> localPreKeyPairs;
  late List<Tuple2<int, SignedPreKeyPair>> localSignedPreKeyPairs = [];

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
  IdentityKeyPair getLocalIdentityKeyPair() {
    return localIdentityKeyPair;
  }

  @override
  PreKeyPair getLocalPreKeyPair(int preKeyId) =>
      _findExistingById(localPreKeyPairs, preKeyId)!.item2;

  @override
  SignedPreKeyPair getLocalSignedPreKeyPair(int signedPreKeyId) =>
      _findExistingById(localSignedPreKeyPairs, signedPreKeyId)!.item2;

  @override
  Session getSession() {
    throw UnimplementedError();
  }

  @override
  bool hasSession() {
    throw UnimplementedError();
  }

  @override
  initKeys() {
    throw UnimplementedError();
  }

  @override
  bool isRemoteIdentityTrusted() {
    throw UnimplementedError();
  }

  @override
  Session putSession(Session session) {
    throw UnimplementedError();
  }

  @override
  setLocalPreKeyPair(List<PreKeyPair> prekeys) {
    localPreKeyPairs =
        prekeys.map<Tuple2<int, PreKeyPair>>((e) => Tuple2(e.preKeyId, e));
  }

  @override
  void addLocalSignedPreKeyPair(SignedPreKeyPair signedPreKey) {
    final existing =
        _findExistingById(localSignedPreKeyPairs, signedPreKey.signedPreKeyId);
    if (existing == null) {
      localSignedPreKeyPairs.add(Tuple2<int, SignedPreKeyPair>(
          signedPreKey.signedPreKeyId, signedPreKey));
    }
  }
}
