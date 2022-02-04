import 'dart:typed_data';

abstract class ECDHKey {
  Future<Uint8List> get bytes;
}
