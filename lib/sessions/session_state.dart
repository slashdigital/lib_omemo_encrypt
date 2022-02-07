import 'dart:typed_data';
import 'package:collection/collection.dart';

import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_key.dart';
import 'package:lib_omemo_encrypt/keys/whisper/pending_prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/rachet/chain.dart';
import 'package:lib_omemo_encrypt/rachet/publickey_and_chain.dart';
import 'package:lib_omemo_encrypt/sessions/session_user.dart';

const maximumRetainedReceivedChainKeys = 20;
Function eq = const ListEquality().equals;

class SessionState {
  final SessionUser sessionUser;
  final int sessionVersion;
  final IdentityKey remoteIdentityKey;
  final IdentityKey localIdentityKey;
  late final String localRegistrationId;
  // Ratchet parameters
  final Uint8List rootKey;
  final Chain sendingChain;
  final ECDHKeyPair senderRatchetKeyPair;
  // Keep a small list of chain keys to allow for out of order message delivery.
  final List<PublicKeyAndChain> receivingChains;
  // In clone
  // TODO: define when this is in used?
  int previousCounter = 0;
  PendingPreKey? pending;
  // Not in clone
  PreKey? theirBaseKey;

  SessionState({
    required this.sessionUser,
    required this.sessionVersion,
    required this.remoteIdentityKey,
    required this.localIdentityKey,
    required this.rootKey,
    required this.sendingChain,
    required this.senderRatchetKeyPair,
    required this.receivingChains,
  });

  Future<bool> _compareKey(
      ECDHPublicKey theirKey, ECDHPublicKey storingKey) async {
    final theirByte = await theirKey.bytes;
    final storingByte = await storingKey.bytes;
    return eq(theirByte, storingByte);
  }

  Future<Chain?> findReceivingChain(
      ECDHPublicKey theirEphemeralPublicKey) async {
    for (var i = 0; i < receivingChains.length; i++) {
      final receivingChain = receivingChains[i];
      if (await _compareKey(
          theirEphemeralPublicKey, receivingChain.ephemeralPublicKey)) {
        return receivingChain.chain;
      }
    }
    return null;
  }

  addReceivingChain(ECDHPublicKey theirEphemeralPublicKey, Chain chain) async {
    receivingChains.add(PublicKeyAndChain(
        ephemeralPublicKey: theirEphemeralPublicKey, chain: chain));
    // We don't keep an infinite number of chain keys, as this would compromise forward secrecy.
    if (receivingChains.length > maximumRetainedReceivedChainKeys) {
      receivingChains.removeAt(0);
    }
  }

  setReceivingChain(ECDHPublicKey theirEphemeralPublicKey, Chain chain) async {
    int index = -1;
    for (var i = 0; i < receivingChains.length; i++) {
      final receivingChain = receivingChains[i];
      if (await _compareKey(
          theirEphemeralPublicKey, receivingChain.ephemeralPublicKey)) {
        index = i;
        break;
      }
    }
    if (index != -1) {
      receivingChains[index].chain = chain;
    }
  }

  SessionState clone() {
    final clonedSessionState = SessionState(
        sessionUser: sessionUser,
        sessionVersion: sessionVersion,
        remoteIdentityKey: remoteIdentityKey,
        localIdentityKey: localIdentityKey,
        rootKey: rootKey,
        sendingChain: sendingChain,
        senderRatchetKeyPair: senderRatchetKeyPair,
        receivingChains: receivingChains);
    clonedSessionState.previousCounter = previousCounter;
    clonedSessionState.pending = pending;
    return clonedSessionState;
  }
}
