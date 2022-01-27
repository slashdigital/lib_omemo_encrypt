import 'dart:typed_data';

class MessageKey {
  final Uint8List cipherKey;
  final Uint8List macKey;
  final Uint8List iv;

  const MessageKey(
      {required this.cipherKey, required this.macKey, required this.iv});
}
