import 'dart:core';
import 'dart:typed_data';

// import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
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

//   // Client parameters
//   // TODO: Make these configurable?
//   maximumRetainedReceivedChainKeys: 5,
//   maximumMissedMessages: 2000,
//   maximumSessionStatesPerIdentity: 40

class Rachet extends RachetInterface {
  final algorithm = HKDFv3();
  final algorithmx25519 = X25519();

  @override
  Future<Chain> clickSubRachet(Chain chain) async {
    return chain.copyWith(
        index: chain.index++, key: await deriveNextChainKey(chain.key));
  }

  @override
  KeyAndChain deriveInitialRootKeyAndChain(sessionVersion, agreements) {
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
    final hmac = Hmac.sha256();
    final mac = await hmac.calculateMac(
      [messageKeySeed],
      secretKey: SecretKey(chainKey),
    );
    return Uint8List.fromList(mac.bytes);
  }

  @override
  Future<MessageKey> deriveMessageKeys(Uint8List chainKey) async {
    final messageKey = await deriveMessageKey(chainKey);
    final keyMaterialBytes = algorithm.deriveSecrets(
        messageKey,
        whisperMessageKeys.asUint8List(),
        cipherKeyByteCount + macKeyByteCount + ivByteCount);
    final ciperKeyBytes = keyMaterialBytes.sublist(0, cipherKeyByteCount);
    final macKeyBytes = keyMaterialBytes
        .sublist(cipherKeyByteCount + cipherKeyByteCount + macKeyByteCount);
    final ivBytes =
        keyMaterialBytes.sublist(cipherKeyByteCount + macKeyByteCount);
    return MessageKey(
        cipherKey: ciperKeyBytes, macKey: macKeyBytes, iv: ivBytes);
  }

  @override
  Future<KeyAndChain> deriveNextRootKeyAndChain(
      rootKey, theirEphemeralPublicKey, ourEphemeralPrivateKey) async {
    var sharedSecret = await algorithmx25519.sharedSecretKey(
        keyPair: ourEphemeralPrivateKey,
        remotePublicKey:
            theirEphemeralPublicKey); //  yield crypto.calculateAgreement(theirEphemeralPublicKey, ourEphemeralPrivateKey);
    var derivedSecretBytes = algorithm.deriveSecrets4(
        Uint8List.fromList(await sharedSecret.extractBytes()),
        rootKey,
        whisperRatchet.asUint8List(),
        rootKeyByteCount + chainKeyByteCount);

    return KeyAndChain(
        rootKey: derivedSecretBytes.sublist(0, rootKeyByteCount),
        chain: Chain(derivedSecretBytes.sublist(rootKeyByteCount)));
  }

  @override
  Future<Uint8List> deriveNextChainKey(Uint8List chainKey) async {
    final hmac = Hmac.sha256();
    final mac = await hmac.calculateMac(
      [chainKeySeed],
      secretKey: SecretKey(chainKey),
    );
    return Uint8List.fromList(mac.bytes);
  }

  @override
  hmacByte() {
    // TODO: implement hmacByte
    throw UnimplementedError();
  }
}
