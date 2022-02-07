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

### Implement storage for your application

You should extend and implement the storage of the `storage/storage_interface.dart` which you could do:

- Init keys
- Store local identity, prekey, registration id, session
- Load back session, registration id, local identity key 

### Generate the first key for your first install of application of the user (or relogin)

```dart

import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';

void main() {
    final axolotl = Axolotl();
    final alicekeyPackage = await axolotl.generatePreKeysPackage(preKeys);
    // ... next codes

```

As Alice, you can init your storage with the new keys and publish to server:

```dart


    // ..
    final aliceStore = MemoryStorage(
      localRegistrationId: alicekeyPackage.registrationId,
      localIdentityKeyPair: alicekeyPackage.identityKeyPair,
    );
    // Store your local pre keys
    aliceStore.setLocalPreKeyPair(alicekeyPackage.preKeys);
    // Publish your key to server based on your implementation
    // Let's say bob will fetch it


```

Bob fetch the keys from server and try to create session to catch

```dart

    // as bob, you init your own  keys

    final bobKeyPackage = await axolotl.generatePreKeysPackage(preKeys);
    final bobStore = MemoryStorage(
      localRegistrationId: bobKeyPackage.registrationId,
      localIdentityKeyPair: bobKeyPackage.identityKeyPair,
    );
    // Store your local pre keys
    bobStore.setLocalPreKeyPair(bobKeyPackage.preKeys);

    // You fetch alice key from server
    final bobReceivingPreKeyPublic = alicePreKey_fromServer;
    final bobReceivingSignKey = aliceSignedPreKey_fromServer;
    final bobReceivingIdentityKey = aliceSignedIdentityKey_fromServer;
    final signature = aliceSignature_fromServer;

    // Alice set key for Bob # use key 0
    const aliceUserId = 'alice@example.co'; // From server (e.g. in chat app you can fetch their id based on your implementation)
    final bobReceivingBundle = ReceivingPreKeyBundle(
        userId: aliceUserId,
        identityKey: bobReceivingIdentityKey,
        preKey: bobReceivingPreKeyPublic,
        signedPreKey: bobReceivingSignKey,
        signature: signature);


```

As bob, you are ready to create session:

```dart

    // Bob try to init the first cipher session
    final bobSessionFactory = SessionFactory(store: bobStore);
    var bobSession = await bobSessionFactory
        .createSessionFromPreKeyBundle(bobReceivingBundle);

    final bobCipherSession = SessionCipher();

    // Bob can encrypt message and set new session state
    final encryptedMsg = await bobCipherSession.encryptMessage(
        senderSession, Utils.convertStringToBytes('Hello Alice'));
    // Important to set back the latest session
    bobSession = encryptedMsg.session;


```

Now as Alice, you are receiving the prekey whisper message from bob:

```dart

    
    final aliceSessionFactory = SessionFactory(store: aliceStore);
    final aliceCipherSession = SessionCipher();

    Session _aliceSession = Session();
    // Encrypted message from Bob
    if (encryptedMsg.isPreKeyWhisperMessage) {

        // You can session from prekey whisper message
        final _ciperSession =
            await aliceSessionFactory.createSessionFromPreKeyWhisperMessage(
                _aliceSession, encryptedMsg.body);
        // Important to set back the latest session
        _aliceSession = _ciperSession.session;

        final decrypedMessage = await aliceCipherSession
            .decryptPreKeyWhisperMessage(_aliceSession, encryptedMsg.body);

        Log.instance.d(tag, 'Plain text: ${utf8.decode(decrypedMessage.plainText)}');
    } else {
    }

```

Now as Alice, you can want to send back the message to Bob:


```dart

    // Alice can encrypt message from session to 
    final encryptedMsg = await aliceCipherSession.encryptMessage(
        senderSession, Utils.convertStringToBytes('Hi Bob'));
    // Important to set back the latest session
    _aliceSession = encryptedMsg.session;

```

And now Bob, you receive the message from Alice.
You receive it as non-prekey whisper message.

```dart

    // Encrypted message from Alice
    if (encryptedMsg.isPreKeyWhisperMessage == false) {
        final decrypedMessage = await bobCipherSession
            .decryptWhisperMessage(bobSession, encryptedMsg.body);
        // Important to set back the latest session
        bobSession = decrypedMessage.session;

        Log.instance.d(tag, 'Plain text: ${utf8.decode(decrypedMessage.plainText)}');
    } else {
    }

// Closing above main
}

```

## Additional information

TODO: to add

## Development

- Update package: `dart pub get`

### Use protobuf

- add plugin `dart pub global activate protoc_plugin` / install it to mac: `brew install protobuf` (https://github.com/google/protobuf.dart/tree/master/protoc_plugin)
- Run

```

protoc --proto_path=./ --plugin=protoc-gen-dart=$HOME/.pub-cache/bin/protoc-gen-dart  --dart_out=./ lib/protobuf/OMEMOMessage.proto  lib/protobuf/OMEMOKeyExchange.proto  lib/protobuf/OMEMOAuthenticatedMessage.proto lib/protobuf/WhisperSenderMessage.proto lib/protobuf/WhisperSenderDistributionMessage.proto

```

### Write test

### Running test


- Generate mock classes: `dart run build_runner build`
- Run test: `flutter test`
- Run coverage: `flutter test --coverage --test-randomize-ordering-seed random`
### Show coverage report with cov gobally

- (once) Add global cov: `flutter pub global activate test_cov_console`
- Run to see report:  flutter pub global run test_cov_console
