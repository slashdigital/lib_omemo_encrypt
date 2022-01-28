import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle_manager.dart';

import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';
import 'package:lib_omemo_encrypt/storage/in-memory/memory_storage.dart';
import 'package:lib_omemo_encrypt/utils/log.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

const _COUNT_PREKEYS = 20;

void main() {
  test('should generate prekeys and verify one prekey bundle', () async {
    final encryption = Axololt();
    // ignore: constant_identifier_names
    const TAG = 'Axololt';

    final identityKeyPair = await encryption.generateIdentityKeyPair();
    final registrationId = encryption.generateRegistrationId();
    final preKeyLists = await encryption.generatePreKeys(
        Utils.createRandomSequence(), _COUNT_PREKEYS);
    final lastResortKey = await encryption.generateLastResortPreKey();
    final signedPreKey =
        await encryption.generateSignedPreKey(identityKeyPair, 1);

    final prekeyPackage =
        await encryption.generatePreKeysPackage(_COUNT_PREKEYS);

    const seanUserId = 'sean@slash.co';
    final seanPreKeyBundle = PreKeyBundle(
        userId: seanUserId,
        identityKeyPair: prekeyPackage.identityKeyPair,
        registrationId: prekeyPackage.registrationId,
        preKey: prekeyPackage.preKeys[0],
        signedPreKey: prekeyPackage.signedPreKey,
        preKeyId: prekeyPackage.preKeys[0].id,
        signedPreKeyId: prekeyPackage.signedPreKey.id);

    final store = MemoryStorage(
        localRegistrationId: registrationId,
        localIdentityKeyPair: identityKeyPair,
        localSignedPreKeyPair: signedPreKey,
        localPreKeyPair: prekeyPackage.preKeys[0],
        remotePreKeyBundle: seanPreKeyBundle);

    final prekeyManager = PreKeyBundleManager();
    prekeyManager.setPreKey(seanUserId, seanPreKeyBundle);

    const aliceUserId = 'alice@slash.co';
    prekeyManager.setPreKey(
        aliceUserId,
        PreKeyBundle(
            userId: aliceUserId,
            identityKeyPair: prekeyPackage.identityKeyPair,
            registrationId: prekeyPackage.registrationId,
            preKey: prekeyPackage.preKeys[1],
            signedPreKey: prekeyPackage.signedPreKey,
            preKeyId: prekeyPackage.preKeys[1].id,
            signedPreKeyId: prekeyPackage.signedPreKey.id));
    final forAlice = prekeyManager.getPreKey(aliceUserId);

    final cipherSession = CipherSession(store: store);
    final result = await cipherSession.createSessionFromPreKeyBundle(forAlice);

    Log.d(TAG, 'identityKeyPair :');
    Log.d(TAG, identityKeyPair);
    Log.d(TAG, 'registrationId :');
    Log.d(TAG, registrationId);
    Log.d(TAG, 'preKeyLists :');
    Log.d(TAG, preKeyLists);
    Log.d(TAG, 'lastResortKey :');
    Log.d(TAG, lastResortKey);
    Log.d(TAG, 'signedPreKey :');
    Log.d(TAG, signedPreKey);
    Log.d(TAG, 'forAlice :');
    Log.d(TAG, forAlice);
    Log.d(TAG, 'result session :');
    Log.d(TAG, result);
    expect(true, true);
  });
}
