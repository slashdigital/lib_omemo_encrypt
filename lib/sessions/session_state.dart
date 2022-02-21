import 'dart:typed_data';
import 'package:collection/collection.dart';

import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/identity_key.dart';
import 'package:lib_omemo_encrypt/keys/whisper/pending_prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/ratchet/chain.dart';
import 'package:lib_omemo_encrypt/ratchet/publickey_and_chain.dart';
import 'package:lib_omemo_encrypt/serialization/serialization_interface.dart';
import 'package:lib_omemo_encrypt/utils/log.dart';
import 'package:lib_omemo_encrypt/protobuf/LocalStorage.pb.dart' as local_proto;

const maximumRetainedReceivedChainKeys = 20;
Function eq = const ListEquality().equals;

class SessionState
    implements Serializable<SessionState, local_proto.LocalSessionState> {
  late int sessionVersion;
  late IdentityKey remoteIdentityKey;
  late IdentityKey localIdentityKey;
  // Ratchet parameters
  late Uint8List rootKey;
  late Chain sendingChain;
  late ECDHKeyPair senderRatchetKeyPair;
  // Keep a small list of chain keys to allow for out of order message delivery.
  List<PublicKeyAndChain> receivingChains = [];
  // In clone
  // TODO: define when this is in used?
  int previousCounter = 0;
  PendingPreKey? pending;
  String localRegistrationId = '';
  // Not in clone
  PreKey? theirBaseKey;

  SessionState();

  SessionState.create({
    required this.sessionVersion,
    required this.remoteIdentityKey,
    required this.localIdentityKey,
    required this.rootKey,
    required this.sendingChain,
    required this.senderRatchetKeyPair,
    required this.receivingChains,
    required this.localRegistrationId,
    this.previousCounter = 0,
    this.pending,
    this.theirBaseKey,
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
    receivingChains.add(PublicKeyAndChain.create(
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
    final clonedSessionState = SessionState.create(
        sessionVersion: sessionVersion,
        remoteIdentityKey: remoteIdentityKey,
        localIdentityKey: localIdentityKey,
        rootKey: rootKey,
        sendingChain: sendingChain,
        senderRatchetKeyPair: senderRatchetKeyPair,
        receivingChains: receivingChains,
        localRegistrationId: localRegistrationId,
        previousCounter: previousCounter,
        pending: pending);
    return clonedSessionState;
  }

  @override
  Future<SessionState> deserialize(Uint8List bytes) async {
    final proto = local_proto.LocalSessionState.fromBuffer(bytes);
    final List<PublicKeyAndChain> mappedPublicKeyAndChains = [];
    for (var receivingChain in proto.receivingChains) {
      mappedPublicKeyAndChains.add(await PublicKeyAndChain()
          .deserialize(receivingChain.writeToBuffer()));
    }
    PendingPreKey? pending;
    try {
      pending =
          await PendingPreKey().deserialize(proto.pending.writeToBuffer());
    } catch (e) {
      Log.instance.e('session_state',
          'Could not deserialize pending since it is probably null');
    }
    return SessionState.create(
        sessionVersion: proto.sessionVersion,
        remoteIdentityKey: await IdentityKey()
            .deserialize(proto.remoteIdentityKey.writeToBuffer()),
        localIdentityKey: await IdentityKey()
            .deserialize(proto.localIdentityKey.writeToBuffer()),
        rootKey: Uint8List.fromList(proto.rootKey),
        sendingChain:
            await Chain().deserialize(proto.sendingChain.writeToBuffer()),
        senderRatchetKeyPair: await ECDHKeyPair()
            .deserialize(proto.senderRatchetKeyPair.writeToBuffer()),
        receivingChains: mappedPublicKeyAndChains,
        localRegistrationId: proto.localRegistrationId,
        previousCounter: proto.previousCounter,
        pending: pending);
  }

  @override
  Future<Uint8List> serialize() async {
    return (await serializeToProto()).writeToBuffer();
  }

  @override
  Future<local_proto.LocalSessionState> serializeToProto() async {
    final List<local_proto.LocalPublicKeyAndChain> mappedPublicKeyAndChains =
        [];
    for (var receivingChain in receivingChains) {
      mappedPublicKeyAndChains.add(await receivingChain.serializeToProto());
    }
    return local_proto.LocalSessionState(
      localIdentityKey: await localIdentityKey.serializeToProto(),
      localRegistrationId: localRegistrationId,
      remoteIdentityKey: await remoteIdentityKey.serializeToProto(),
      sessionVersion: sessionVersion,
      rootKey: rootKey,
      sendingChain: await sendingChain.serializeToProto(),
      senderRatchetKeyPair: await senderRatchetKeyPair.serializeToProto(),
      receivingChains: mappedPublicKeyAndChains.map((e) => e),
      previousCounter: previousCounter,
      pending: pending != null ? await pending!.serializeToProto() : null,
      theirBaseKey:
          theirBaseKey != null ? await theirBaseKey!.serializeToProto() : null,
    );
  }
}
