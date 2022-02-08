import 'dart:typed_data';

import 'package:lib_omemo_encrypt/ratchet/chain.dart';

class KeyAndChain {
  final Uint8List rootKey;
  final Chain chain;

  const KeyAndChain({required this.rootKey, required this.chain});
}
