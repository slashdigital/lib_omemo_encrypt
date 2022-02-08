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

      final keyPair = ECDHKeyPair.create(await algorithm.newKeyPair());
      final publicKey = await keyPair.publicKey;

      final publicKeyAndChain = PublicKeyAndChain.create(
          ephemeralPublicKey: publicKey, chain: recievingChain);

      final remoteIdentityKeyPair = IdentityKeyPair.create(
          key: ECDHKeyPair.create(await algorithm.newKeyPair()));
      final localIdentityKeyPair = IdentityKeyPair.create(
          key: ECDHKeyPair.create(await algorithm.newKeyPair()));
      final rootKey =
          Uint8List.fromList(Utils.convertStringToBytes('root_key'));
      final senderRatchetKeyPair =
          ECDHKeyPair.create(await algorithm.newKeyPair());

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
