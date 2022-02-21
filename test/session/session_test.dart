import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_keypair.dart';
import 'package:lib_omemo_encrypt/ratchet/chain.dart';
import 'package:lib_omemo_encrypt/ratchet/message_key.dart';
import 'package:lib_omemo_encrypt/ratchet/publickey_and_chain.dart';
import 'package:lib_omemo_encrypt/sessions/session_state.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

void main() {
  final algorithm = X25519();
  group('session/session_state.dart', () {
    test('Should serialize session state and parse it back', () async {
      final messageKey = MessageKey.create(
          cipherKey: Uint8List.fromList(Utils.convertStringToBytes('key')),
          macKey: Uint8List.fromList(Utils.convertStringToBytes('mac')),
          iv: Uint8List.fromList(Utils.convertStringToBytes('iv')));
      final messageKeyNext = MessageKey.create(
          cipherKey: Uint8List.fromList(Utils.convertStringToBytes('key_next')),
          macKey: Uint8List.fromList(Utils.convertStringToBytes('mac_next')),
          iv: Uint8List.fromList(Utils.convertStringToBytes('iv_next')));

      final chain = Chain.create(
          Uint8List.fromList(Utils.convertStringToBytes('chainKeys')),
          index: 0,
          messageKeysList: [messageKey, messageKeyNext]);
      final recievingChain = Chain.create(
          Uint8List.fromList(Utils.convertStringToBytes('chainKeys')),
          index: 0,
          messageKeysList: [messageKey, messageKeyNext]);

      final xKeyPair = await algorithm.newKeyPair();
      final keyPair =
          ECDHKeyPair.createPair(xKeyPair, await xKeyPair.extractPublicKey());
      final publicKey = await keyPair.publicKey;

      final publicKeyAndChain = PublicKeyAndChain.create(
          ephemeralPublicKey: publicKey, chain: recievingChain);

      final xRemoteKeyPair = await algorithm.newKeyPair();
      final remoteIdentityKeyPair = IdentityKeyPair.create(
          key: ECDHKeyPair.createPair(
              xRemoteKeyPair, await xRemoteKeyPair.extractPublicKey()));
      final xLocalKeyPair = await algorithm.newKeyPair();
      final localIdentityKeyPair = IdentityKeyPair.create(
          key: ECDHKeyPair.createPair(
              xLocalKeyPair, await xLocalKeyPair.extractPublicKey()));
      final rootKey =
          Uint8List.fromList(Utils.convertStringToBytes('root_key'));
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
          localRegistrationId: '123');

      final serialized = await sessionState.serialize();

      final parsedSessionState = await SessionState().deserialize(serialized);

      final serializedFromNewState = await parsedSessionState.serialize();
      expect(serialized, serializedFromNewState);
    });
  });
}
