import 'dart:typed_data';

class ArrayBufferUtils {
  static concat(List<ByteBuffer> buffers) {
    // final _buffers = (buffers.length == 1) ? buffers[0] : buffers;
    var i;
    var byteLength = 0;
    for (i = 0; i < buffers; i++) {
      byteLength += buffers[i].lengthInBytes;
    }
    var newBuffer = Uint8List(byteLength);
    var offset = 0;
    for (i = 0; i < buffers.length; i++) {
      newBuffer.setAll(offset,
          buffers[i].asUint8List()); // (new Uint8Array(buffers[i]), offset);
      offset += buffers[i].lengthInBytes;
    }
    return newBuffer;
  }
}
