import 'dart:typed_data';
import 'dart:collection';

import 'package:lib_omemo_encrypt/kdf/hkdf/hkdfv3.dart';
import 'package:crypto/crypto.dart' as crypto;

class SenderMessageKey {
  SenderMessageKey(this._iteration, this._seed) {
    // final derivative = HKDFv3()
    //     .deriveSecrets(seed, Uint8List.fromList('WhisperGroup'.codeUnits), 48);
    final derivative = HKDFv3()
        .deriveSecrets(seed, Uint8List.fromList('WhisperGroup'.codeUnits), 48);
    _iv = derivative.sublist(0, 16);
    _cipherKey = derivative.sublist(16);
  }

  final int _iteration;
  final Uint8List _seed;
  late Uint8List _iv;
  late Uint8List _cipherKey;

  int get iteration => _iteration;
  Uint8List get iv => _iv;
  Uint8List get cipherKey => _cipherKey;
  Uint8List get seed => _seed;
}

class SenderChainKey {
  SenderChainKey(this._iteration, this._chainKey);

  static final Uint8List _messageKeySeed = Uint8List.fromList([0x01]);
  static final Uint8List _chainKeySeed = Uint8List.fromList([0x02]);

  final int _iteration;
  final Uint8List _chainKey;

  int get iteration => _iteration;

  Uint8List get seed => _chainKey;

  SenderMessageKey get senderMessageKey =>
      SenderMessageKey(_iteration, getDerivative(_messageKeySeed, _chainKey));

  SenderChainKey get next =>
      SenderChainKey(_iteration + 1, getDerivative(_chainKeySeed, _chainKey));

  Uint8List getDerivative(Uint8List seed, Uint8List key) {
    final hmacSha256 = crypto.Hmac(crypto.sha256, key);
    final digest = hmacSha256.convert(seed);
    return Uint8List.fromList(digest.bytes);
  }
}

class SenderKeyStateStructure {
  final int senderKeyId;
  SenderKeyStateStructureSenderChainKey senderChainKey;
  final SenderKeyStateStructureSenderSigningKey senderSigningKey;
  List<SenderKeyStateStructureSenderMessageKey> senderMessageKeys = [];

  SenderKeyStateStructure(
      this.senderKeyId, this.senderChainKey, this.senderSigningKey);
}

class SenderKeyStateStructureSenderChainKey {
  final int iteration;
  final Uint8List seed;

  SenderKeyStateStructureSenderChainKey(this.iteration, this.seed);
}

class SenderKeyStateStructureSenderMessageKey {
  final int iteration;
  final Uint8List seed;

  SenderKeyStateStructureSenderMessageKey(this.iteration, this.seed);
}

class SenderKeyStateStructureSenderSigningKey {
  final Uint8List public;
  Uint8List? private;

  SenderKeyStateStructureSenderSigningKey(this.public);
}

class SenderKeyRecordStructure {
  List<SenderKeyStateStructure>? senderKeyStates;
}

class Entry<T> extends LinkedListEntry<Entry<T>> {
  Entry(this.value);
  T value;

  @override
  String toString() => '$value';
}
