import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/rachet/chain.dart';

class PublicKeyAndChain {
  PublicKey ephemeralPublicKey;
  Chain chain;

  PublicKeyAndChain({required this.ephemeralPublicKey, required this.chain});
}
