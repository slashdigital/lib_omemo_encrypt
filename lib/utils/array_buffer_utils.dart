import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

class ArrayBufferUtils {
  static Uint8List concat(List<ByteBuffer> buffers) {
    var byteLength = 0;
    for (var i = 0; i < buffers.length; i++) {
      byteLength += buffers[i].lengthInBytes;
    }
    var newBuffer = Uint8List(byteLength);
    var offset = 0;
    for (var i = 0; i < buffers.length; i++) {
      newBuffer.setAll(offset, buffers[i].asUint8List());
      offset += buffers[i].lengthInBytes;
    }
    return newBuffer;
  }

  static ByteBuffer getBuffer(List<int> listBytes) {
    return Uint8List.fromList(listBytes).buffer;
  }

  static Future<List<int>> getBytesList(SecretKey secretKey) async {
    return await secretKey.extractBytes();
  }

  static Future<ByteBuffer> getBytesBuffer(SecretKey secretKey) async {
    return getBuffer(await secretKey.extractBytes());
  }

  static ByteBuffer fromByte(int byte) => Uint8List.fromList([byte]).buffer;
}
