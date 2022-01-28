import 'package:cryptography/cryptography.dart';
import 'package:lib_omemo_encrypt/rachet/chain.dart';

class PublicKeyAndChain {
  final PublicKey ephemeralPublicKey;
  final Chain chain;

  const PublicKeyAndChain(
      {required this.ephemeralPublicKey, required this.chain});
}
