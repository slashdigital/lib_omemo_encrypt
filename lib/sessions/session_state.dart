import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/keys/key.dart';
import 'package:lib_omemo_encrypt/keys/pending_prekey.dart';
import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';
import 'package:lib_omemo_encrypt/rachet/chain.dart';
import 'package:lib_omemo_encrypt/rachet/key_and_chain.dart';
import 'package:lib_omemo_encrypt/rachet/publickey_and_chain.dart';

const maximumRetainedReceivedChainKeys = 20;

class SessionState {
  final int sessionVersion;
  final SimplePublicKey remoteIdentityKey; // their
  final SimplePublicKey localIdentityKey;
  late final String localRegistrationId;
  SimplePublicKey? theirBaseKey;
  // Ratchet parameters
  final Uint8List rootKey;
  final Chain sendingChain;
  final SimpleKeyPair senderRatchetKeyPair;
  final List<PublicKeyAndChain> receivingChains =
      []; // Keep a small list of chain keys to allow for out of order message delivery.
  final int previousCounter = 0;
  PendingPreKey? pending;

  SessionState({
    required this.sessionVersion,
    required this.remoteIdentityKey,
    required this.localIdentityKey,
    required this.rootKey,
    required this.sendingChain,
    required this.senderRatchetKeyPair,
  });

  Chain? findReceivingChain(SimplePublicKey theirEphemeralPublicKey) {
    final keyPair = theirEphemeralPublicKey;
    for (var i = 0; i < receivingChains.length; i++) {
      var receivingChain = receivingChains[i];
      if (keyPair == receivingChain.ephemeralPublicKey) {
        return receivingChain.chain;
      }
    }
    return null;
  }

  addReceivingChain(PublicKey theirEphemeralPublicKey, Chain chain) async {
    receivingChains.add(PublicKeyAndChain(
        ephemeralPublicKey: theirEphemeralPublicKey, chain: chain));
    // We don't keep an infinite number of chain keys, as this would compromise forward secrecy.
    if (receivingChains.length > maximumRetainedReceivedChainKeys) {
      receivingChains.removeAt(0);
    }
  }

  setReceivingChain(PublicKey theirEphemeralPublicKey, Chain chain) async {
    final index = receivingChains.indexWhere((receivingChain) =>
        receivingChain.ephemeralPublicKey == theirEphemeralPublicKey);
    if (index != -1) {
      receivingChains[index].chain = chain;
    }
  }
}
