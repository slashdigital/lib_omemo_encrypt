Library for Axololt Signal/Omemo-like encryption 
## Features

- Generate identifer key-pair
- Generate prekey list
- Generate signed key
- Generate last resort prekeys


## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

```dart

  import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';

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
  const aliceUserId = 'alice@slash.co';
  prekeyManager.setPreKey(
      aliceUserId,
      PreKeyBundle(
          userId: aliceUserId,
          identityKeyPair: prekeyPackage.identityKeyPair,
          registrationId: prekeyPackage.registrationId,
          preKey: prekeyPackage.preKeys[0],
          signedPreKey: prekeyPackage.signedPreKey));
  final forAlice = prekeyManager.getPreKey(aliceUserId);

  final cipherSession = CipherSession();
  final result = await cipherSession.createSessionFromPreKeyBundle(forAlice);

  // TODO: add method create cipher sessions

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

```

## Additional information

TODO: to add

## Development

- Update package: `dart pub get`

### Write test

### Running test


- Generate mock classes: `dart run build_runner build`
- Run test: `flutter test`
- Run coverage: `flutter test --coverage --test-randomize-ordering-seed random`
### Show coverage report with cov gobally

- (once) Add global cov: `flutter pub global activate test_cov_console`
- Run to see report:  flutter pub global run test_cov_console
