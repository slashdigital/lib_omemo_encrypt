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
  Future<IdentityKeyPair> getLocalIdentityKeyPair() async {
    return localIdentityKeyPair;
  }

  @override
  Future<PreKeyPair> getLocalPreKeyPair(int preKeyId) async =>
      _findExistingById(localPreKeyPairs, preKeyId)!.item2;

  @override
  Future<SignedPreKeyPair> getLocalSignedPreKeyPair(int signedPreKeyId) async =>
      _findExistingById(localSignedPreKeyPairs, signedPreKeyId)!.item2;

  @override
  Future<Session> getSession(
      {required bool isGroup,
      required String groupJabberId,
      required String buddyJid,
      required String deviceId}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> hasSession(
      {required bool isGroup,
      required String groupJabberId,
      required String buddyJid}) {
    throw UnimplementedError();
  }

  @override
  initKeys() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isRemoteIdentityTrusted() {
    throw UnimplementedError();
  }

  @override
  Future<Session> putSession(
      {required Session session,
      required bool isGroup,
      required String buddyJid, // Required to have buddyJid
      required String deviceId, // Required to have deviceid with buddyJid
      required String groupJabberId, // can be '' if not group
      required Iterable<String> participants}) {
    throw UnimplementedError();
  }

  @override
  Future<void> setLocalPreKeyPair(List<PreKeyPair> prekeys) async {
    localPreKeyPairs =
        prekeys.map<Tuple2<int, PreKeyPair>>((e) => Tuple2(e.preKeyId, e));
  }

  @override
  Future<void> addLocalSignedPreKeyPair(SignedPreKeyPair signedPreKey) async {
    final existing =
        _findExistingById(localSignedPreKeyPairs, signedPreKey.signedPreKeyId);
    if (existing == null) {
      localSignedPreKeyPairs.add(Tuple2<int, SignedPreKeyPair>(
          signedPreKey.signedPreKeyId, signedPreKey));
    }
  }

  @override
  Future<List> getSessions(
      {required bool isGroup,
      required String groupJabberId,
      required String buddyJid}) {
    throw UnimplementedError();
  }
}
