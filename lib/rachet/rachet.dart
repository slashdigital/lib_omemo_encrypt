import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/encryptions/axolotl/axolotl.dart';
import 'package:lib_omemo_encrypt/kdf/hkdf/hkdfv3.dart';
import 'package:lib_omemo_encrypt/rachet/chain.dart';
import 'package:lib_omemo_encrypt/rachet/key_and_chain.dart';
import 'package:lib_omemo_encrypt/rachet/message_key.dart';
import 'package:lib_omemo_encrypt/rachet/rachet_interface.dart';
import 'package:lib_omemo_encrypt/utils/array_buffer_utils.dart';

const currentVersion = 3;

// Sizes of various fields
const macByteCount = 8;
const cipherKeyByteCount = 32;
const macKeyByteCount = 32;
const ivByteCount = 16;
const dhKeyByteCount = 32;
const rootKeyByteCount = 32;
const chainKeyByteCount = 32;

class Rachet extends RachetInterface {
  final algorithm = HKDFv3();
  final algorithmEd25519 = Ed25519();
  final Axololt axololt = Axololt();

  @override
  Future<Chain> clickSubRachet(Chain chain) async {
    chain.index++;
    chain.key = await deriveNextChainKey(chain.key);
    return chain;
  }

  @override
  KeyAndChain deriveInitialRootKeyAndChain(
      int sessionVersion, List<ByteBuffer> agreements) {
    List<ByteBuffer> secrets = [];

    if (sessionVersion >= 3) {
      secrets.add(discontinuityBytes);
    }
    secrets = [...secrets, ...agreements];
    final masterSecret = ArrayBufferUtils.concat(secrets);
    final derivedSecret = algorithm.deriveSecrets(masterSecret,
        whisperText.asUint8List(), rootKeyByteCount + chainKeyByteCount);
    return KeyAndChain(
        rootKey: derivedSecret.sublist(0, rootKeyByteCount),
        chain: Chain(derivedSecret.sublist(rootKeyByteCount)));
  }

  @override
  Future<Uint8List> deriveMessageKey(Uint8List chainKey) async {
    final hmacSha256 = crypto.Hmac(crypto.sha256, chainKey);
    final digest = hmacSha256.convert([messageKeySeed]);

    return Uint8List.fromList(digest.bytes);
  }

  @override
  Future<MessageKey> deriveMessageKeys(Uint8List chainKey) async {
    final messageKey = await deriveMessageKey(chainKey);

    final keyMaterialBytes = algorithm.deriveSecrets(
        messageKey,
        Uint8List.fromList(utf8.encode('WhisperMessageKeys')),
        cipherKeyByteCount + macKeyByteCount + ivByteCount);

    final ciperKeyBytes = keyMaterialBytes.sublist(0, cipherKeyByteCount);
    final macKeyBytes = keyMaterialBytes.sublist(
        cipherKeyByteCount, cipherKeyByteCount + macKeyByteCount);
    final ivBytes =
        keyMaterialBytes.sublist(cipherKeyByteCount + macKeyByteCount);
    return MessageKey(
        cipherKey: ciperKeyBytes, macKey: macKeyBytes, iv: ivBytes);
  }

  @override
  Future<KeyAndChain> deriveNextRootKeyAndChain(
      Uint8List rootKey,
      SimplePublicKey theirEphemeralPublicKey,
      SimpleKeyPair ourEphemeralPrivateKey) async {
    final sharedSecret = await axololt.calculateAgreement(
        ourEphemeralPrivateKey, theirEphemeralPublicKey);
    var derivedSecretBytes = algorithm.deriveSecrets4(
        sharedSecret.asUint8List(),
        rootKey,
        whisperRatchet.asUint8List(),
        rootKeyByteCount + chainKeyByteCount);

    return KeyAndChain(
        rootKey: derivedSecretBytes.sublist(0, rootKeyByteCount),
        chain: Chain(derivedSecretBytes.sublist(rootKeyByteCount)));
  }

  @override
  Future<Uint8List> deriveNextChainKey(Uint8List chainKey) async {
    final hmacSha256 = crypto.Hmac(crypto.sha256, chainKey);
    final digest = hmacSha256.convert([chainKeySeed]);
    return Uint8List.fromList(digest.bytes);
  }

  @override
  hmacByte() {
    // TODO: implement hmacByte
    throw UnimplementedError();
  }
}
