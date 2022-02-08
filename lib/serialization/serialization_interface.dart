import 'dart:typed_data';

abstract class Serializable<T> {
  Future<Uint8List> serialize();
  Future<T> deserialize(Uint8List bytes);
}
