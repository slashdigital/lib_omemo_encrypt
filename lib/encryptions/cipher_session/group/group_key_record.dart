import 'dart:collection';
import 'dart:typed_data';

import 'package:lib_omemo_encrypt/encryptions/cipher_session/group/group_key_data.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/group/group_key_state.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';

class SenderKeyRecord {
  SenderKeyRecord();

  // SenderKeyRecord.fromSerialized(Uint8List serialized) {
  //   final senderKeyRecordStructure =
  //       SenderKeyRecordStructure.fromBuffer(serialized);
  //   for (final structure in senderKeyRecordStructure.senderKeyStates) {
  //     _senderKeyStates
  //         .add(Entry(SenderKeyState.fromSenderKeyStateStructure(structure)));
  //   }
  // }

  SenderKeyRecord.copyWith(SenderKeyRecordStructure _senderKeyRecordStructure) {
    final senderKeyRecordStructure = SenderKeyRecordStructure();
    senderKeyRecordStructure.senderKeyStates =
        _senderKeyRecordStructure.senderKeyStates;
    for (final structure in senderKeyRecordStructure.senderKeyStates!) {
      _senderKeyStates
          .add(Entry(SenderKeyState.fromSenderKeyStateStructure(structure)));
    }
  }

  static const int _maxStates = 5;

  // final LinkedList<Entry<SenderKeyState>> _senderKeyStates =
  //     LinkedList<Entry<SenderKeyState>>();
  final List<Entry<SenderKeyState>> _senderKeyStates = [];

  bool get isEmpty => _senderKeyStates.isEmpty;

  SenderKeyState getSenderKeyState() {
    if (_senderKeyStates.isNotEmpty) {
      return _senderKeyStates.first.value;
    } else {
      throw Exception('No key state in record!');
    }
  }

  SenderKeyState getSenderKeyStateById(int keyId) {
    for (final state in _senderKeyStates) {
      if (state.value.keyId == keyId) {
        return state.value;
      }
    }
    throw Exception('No key for: $keyId');
  }

  Future<void> addSenderKeyState(int id, int iteration, Uint8List chainKey,
      ECDHPublicKey signatureKey) async {
    // _senderKeyStates.addFirst(Entry(await SenderKeyState.fromPublicKey(
    //     id, iteration, chainKey, signatureKey)));
    // if (_senderKeyStates.length > _maxStates) {
    //   _senderKeyStates.remove(_senderKeyStates.last);
    // }
    _senderKeyStates.insert(
        0,
        Entry(await SenderKeyState.fromPublicKey(
            id, iteration, chainKey, signatureKey)));
    if (_senderKeyStates.length > _maxStates) {
      _senderKeyStates.remove(_senderKeyStates.last);
    }
  }

  Future<void> setSenderKeyState(int id, int iteration, Uint8List chainKey,
      ECDHKeyPair signatureKey) async {
    _senderKeyStates
      ..clear()
      ..add(Entry(await SenderKeyState.fromKeyPair(
          id, iteration, chainKey, signatureKey)));
  }

  SenderKeyRecordStructure clone() {
    final recordStructure = SenderKeyRecordStructure();
    recordStructure.senderKeyStates = [];
    for (var entry in _senderKeyStates) {
      recordStructure.senderKeyStates!.add(entry.value.structure);
    }
    return recordStructure;
  }
}
