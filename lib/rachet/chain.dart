import 'dart:typed_data';

import 'package:lib_omemo_encrypt/rachet/message_key.dart';

class Chain {
  final Uint8List key;
  int index = 0;
  List<MessageKey?> messageKeys = [];

  Chain(this.key, {this.index = 0});

  Chain copyWith({int? index, Uint8List? key}) {
    return Chain(this.key, index: index ?? this.index);
  }
}
