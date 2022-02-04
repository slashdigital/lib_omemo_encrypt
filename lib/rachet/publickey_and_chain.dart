import 'package:lib_omemo_encrypt/keys/ecc/publickey.dart';
import 'package:lib_omemo_encrypt/rachet/chain.dart';

class PublicKeyAndChain {
  ECDHPublicKey ephemeralPublicKey;
  Chain chain;

  PublicKeyAndChain({required this.ephemeralPublicKey, required this.chain});
}
