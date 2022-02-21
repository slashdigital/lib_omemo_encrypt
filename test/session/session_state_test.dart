import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_keypair.dart';
import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';
import 'package:lib_omemo_encrypt/ratchet/chain.dart';
import 'package:lib_omemo_encrypt/ratchet/message_key.dart';
import 'package:lib_omemo_encrypt/ratchet/publickey_and_chain.dart';
import 'package:lib_omemo_encrypt/sessions/session_messaging.dart';
import 'package:lib_omemo_encrypt/sessions/session_state.dart';
import 'package:lib_omemo_encrypt/sessions/session_user.dart';

void main() {
  final algorithm = X25519();
  group('session/session.dart', () {
    test('Should serialize session state and parse it back', () async {
      List<SessionState> states = [];

      for (var i = 0; i < 5; i++) {
        final messageKey = MessageKey.create(
            cipherKey: Uint8List.fromList(Utils.convertStringToBytes('key_$i')),
            macKey: Uint8List.fromList(Utils.convertStringToBytes('mac_$i')),
            iv: Uint8List.fromList(Utils.convertStringToBytes('iv_$i')));
        final messageKeyNext = MessageKey.create(
            cipherKey:
                Uint8List.fromList(Utils.convertStringToBytes('key_next_$i')),
            macKey:
                Uint8List.fromList(Utils.convertStringToBytes('mac_next_$i')),
            iv: Uint8List.fromList(Utils.convertStringToBytes('iv_next_$i')));

        final chain = Chain.create(
            Uint8List.fromList(Utils.convertStringToBytes('chainKeys_$i')),
            index: 0,
            messageKeysList: [messageKey, messageKeyNext]);
        final receivingChain = Chain.create(
            Uint8List.fromList(Utils.convertStringToBytes('chainKeys_$i')),
            index: 0,
            messageKeysList: [messageKey, messageKeyNext]);

        final xKeyPair = await algorithm.newKeyPair();
        final keyPair =
            ECDHKeyPair.createPair(xKeyPair, await xKeyPair.extractPublicKey());
        final publicKey = await keyPair.publicKey;

        final publicKeyAndChain = PublicKeyAndChain.create(
            ephemeralPublicKey: publicKey, chain: receivingChain);

        final xRemoteKeyPair = await algorithm.newKeyPair();
        final remoteIdentityKeyPair = IdentityKeyPair.create(
            key: ECDHKeyPair.createPair(
                xRemoteKeyPair, await xRemoteKeyPair.extractPublicKey()));
        final xLocalKeyPair = await algorithm.newKeyPair();
        final localIdentityKeyPair = IdentityKeyPair.create(
            key: ECDHKeyPair.createPair(
                xLocalKeyPair, await xLocalKeyPair.extractPublicKey()));
        final rootKey =
            Uint8List.fromList(Utils.convertStringToBytes('root_key_$i'));
        final xSenderKeyPair = await algorithm.newKeyPair();
        final senderRatchetKeyPair = ECDHKeyPair.createPair(
            xSenderKeyPair, await xSenderKeyPair.extractPublicKey());

        final sessionState = SessionState.create(
            sessionVersion: 3,
            remoteIdentityKey: await remoteIdentityKeyPair.identityKey,
            localIdentityKey: await localIdentityKeyPair.identityKey,
            rootKey: rootKey,
            sendingChain: chain,
            senderRatchetKeyPair: senderRatchetKeyPair,
            receivingChains: [publicKeyAndChain],
            localRegistrationId: '123_$i');

        states.add(sessionState);
      }
      final Session session = Session.create(
          SessionMessaging.create(
              sessionUser: const SessionUser(deviceId: '1', name: 'alice'),
              sessionGroup: null,
              sessionChatType: SessionChatType.personalChat),
          sessionStates: states);

      final serialized = await session.serialize();

      final parsedSession = await Session().deserialize(serialized);

      final serializedFromNewState = await parsedSession.serialize();
      expect(serialized, serializedFromNewState);
    });
  });
}
