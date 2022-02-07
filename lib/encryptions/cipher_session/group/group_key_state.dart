import 'dart:typed_data';

import 'package:lib_omemo_encrypt/encryptions/cipher_session/group/group_key_data.dart';
import 'package:lib_omemo_encrypt/keys/ecc/keypair.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';

class SenderKeyState {
  static const int _maxMessageKeys = 2000;

  final SenderKeyStateStructure senderKeyStateStructure;
  SenderKeyState(this.senderKeyStateStructure);
  static Future<SenderKeyState> fromPublicKey(int id, int iteration,
      Uint8List chainKey, ECDHPublicKey signatureKeyPublic) async {
    return await init(id, iteration, chainKey, signatureKeyPublic, null);
  }

  static Future<SenderKeyState> fromKeyPair(int id, int iteration,
      Uint8List chainKey, ECDHKeyPair signatureKey) async {
    final signatureKeyPublic = await signatureKey.publicKey;
    final signatureKeyPrivate = signatureKey;
    return await init(
        id, iteration, chainKey, signatureKeyPublic, signatureKeyPrivate);
  }

  static SenderKeyState fromSenderKeyStateStructure(
      SenderKeyStateStructure senderKeyStateStructure) {
    return SenderKeyState(senderKeyStateStructure);
  }

  static Future<SenderKeyState> init(int id, int iteration, Uint8List chainKey,
      ECDHPublicKey signatureKeyPublic,
      [ECDHKeyPair? signatureKeyPrivate]) async {
    final seed = Uint8List.fromList(chainKey);
    final senderChainKeyStructure =
        SenderKeyStateStructureSenderChainKey(iteration, seed);
    final signingKeyStructure =
        SenderKeyStateStructureSenderSigningKey(await signatureKeyPublic.bytes);
    if (signatureKeyPrivate != null) {
      signingKeyStructure.private = await signatureKeyPrivate.bytes;
    }
    final _senderKeyStateStructure = SenderKeyStateStructure(
        id, senderChainKeyStructure, signingKeyStructure);
    return SenderKeyState(_senderKeyStateStructure);
  }

  int get keyId => senderKeyStateStructure.senderKeyId;

  SenderChainKey get senderChainKey => SenderChainKey(
      senderKeyStateStructure.senderChainKey.iteration,
      Uint8List.fromList(senderKeyStateStructure.senderChainKey.seed));

  set senderChainKey(SenderChainKey senderChainKey) => {
        senderKeyStateStructure.senderChainKey =
            SenderKeyStateStructureSenderChainKey(
                senderChainKey.iteration, senderChainKey.seed)
      };

  ECDHPublicKey get signingKeyPublic =>
      ECDHPublicKey.fromBytes(senderKeyStateStructure.senderSigningKey.public);

  Future<ECDHKeyPair> get signingKeyPrivate async =>
      await ECDHKeyPair.fromBytes(
          senderKeyStateStructure.senderSigningKey.private!,
          senderKeyStateStructure.senderSigningKey.public);

  bool hasSenderMessageKey(int iteration) {
    for (final senderMessageKey in senderKeyStateStructure.senderMessageKeys) {
      if (senderMessageKey.iteration == iteration) {
        return true;
      }
    }
    return false;
  }

  void addSenderMessageKey(SenderMessageKey senderMessageKey) {
    final senderMessageKeyStructure = SenderKeyStateStructureSenderMessageKey(
        senderMessageKey.iteration, senderMessageKey.seed);
    senderKeyStateStructure.senderMessageKeys.add(senderMessageKeyStructure);
    if (senderKeyStateStructure.senderMessageKeys.length > _maxMessageKeys) {
      senderKeyStateStructure.senderMessageKeys.removeAt(0);
    }
  }

  SenderMessageKey? removeSenderMessageKey(int iteration) {
    senderKeyStateStructure.senderMessageKeys
        .toList()
        .addAll(senderKeyStateStructure.senderMessageKeys);
    final index = senderKeyStateStructure.senderMessageKeys
        .indexWhere((item) => item.iteration == iteration);
    if (index == -1) return null;
    final senderMessageKey =
        senderKeyStateStructure.senderMessageKeys.removeAt(index);
    return SenderMessageKey(
        senderMessageKey.iteration, Uint8List.fromList(senderMessageKey.seed));
  }

  SenderKeyStateStructure get structure => senderKeyStateStructure;

  @override
  String toString() {
    return keyId.toString();
  }
}
