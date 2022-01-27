import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle_manager.dart';

import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';
import 'package:lib_omemo_encrypt/utils/log.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

const _COUNT_PREKEYS = 20;

void main() {
  test('adds one to input values', () async {
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

    final prekeyManager = PreKeyBundleManager();
    final aliceUserId = 'alice@slash.co';
    prekeyManager.setPreKey(
        aliceUserId,
        PreKeyBundle(
            userId: aliceUserId,
            identityKeyPair: prekeyPackage.identityKeyPair,
            registrationId: prekeyPackage.registrationId,
            preKey: prekeyPackage.preKeys[0],
            signedPreKey: prekeyPackage.signedPreKey));
    final forAlice = prekeyManager.getPreKey(aliceUserId);

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
    expect(1, 1);
  });
}
