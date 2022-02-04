import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/keys/ecc/key.dart';
import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';

class ECDHKeyPair extends ECDHKey implements ECDHPublicKey {
  final SimpleKeyPair? _keyPair;

  SimpleKeyPair get keyPair => _keyPair!;

  bool get hasKeys => _keyPair != null;

  ECDHKeyPair(this._keyPair);

  Future<ECDHPublicKey> get publicKey async =>
      ECDHPublicKey(await keyPair.extractPublicKey());

  @override
  Future<SimplePublicKey> get key async => await keyPair.extractPublicKey();

  static ECDHKeyPair empty() {
    return ECDHKeyPair(null);
  }

  @override
  Future<Uint8List> get bytes async =>
      Uint8List.fromList(await keyPair.extractPrivateKeyBytes());

  Future<Uint8List> get publicKeyBytes async =>
      Uint8List.fromList((await keyPair.extractPublicKey()).bytes);
}
