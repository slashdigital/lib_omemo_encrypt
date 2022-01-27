import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart' as ed;

import 'package:lib_omemo_encrypt/encryptions/cipher_session/cipher_session_interface.dart';
import 'package:lib_omemo_encrypt/exceptions/invalid_key_exception.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';
import 'package:lib_omemo_encrypt/rachet/rachet.dart';

class CipherSession extends CipherSessionInterface {
  final Rachet rachet = Rachet();
  final algorithmx25519 = X25519();
  final algorithmEd25519 = Ed25519();

  CipherSession();

  @override
  createSessionFromPreKeyBundle(PreKeyBundle preKeyBundle) async {
    final validSignature = await algorithmEd25519.verify(
        (await preKeyBundle.identityKeyPair.extractPrivateKeyBytes()).toList(),
        signature: preKeyBundle.signedPreKey.signature);
    if (!validSignature) {
      throw InvalidKeyException('Invalid signature on device key');
    }
    return validSignature;
  }

  // // Sign
  // final message = <int>[1,2,3];
  // final signature = await algorithm.sign(
  //   message,
  //   keyPair: keyPair,
  // );
  // print('Signature bytes: ${signature.bytes}');
  // print('Public key: ${signature.publicKey.bytes}');

  // // Anyone can verify the signature
  // final isVerified = await ed25519.verify(
  //   message,
  //   signature: signature,
  // );
}
