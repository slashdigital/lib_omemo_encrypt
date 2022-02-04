import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/keys/ecc/key.dart';

class ECDHPublicKey extends ECDHKey {
  final SimplePublicKey _publicKey;

  Future<SimplePublicKey> get key async => _publicKey;

  ECDHPublicKey(this._publicKey);

  @override
  Future<Uint8List> get bytes async => Uint8List.fromList(_publicKey.bytes);
}
