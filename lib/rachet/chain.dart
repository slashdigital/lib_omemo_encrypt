import 'dart:typed_data';

import 'package:lib_omemo_encrypt/rachet/message_key.dart';

class Chain {
  Uint8List key;
  int index = 0;
  List<MessageKey?> messageKeys = [];

  Chain(this.key, {this.index = 0});

  Chain copyWith({int? index, Uint8List? key, List<MessageKey?>? messageKeys}) {
    final _chain = Chain(this.key, index: index ?? this.index);
    _chain.messageKeys = messageKeys ?? this.messageKeys;
    return _chain;
  }
}
