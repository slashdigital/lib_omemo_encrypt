import 'dart:typed_data';

abstract class Serializable<T, P> {
  Future<Uint8List> serialize();
  Future<P> serializeToProto();
  Future<T> deserialize(Uint8List bytes);
}
