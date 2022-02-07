import 'dart:convert';
import 'dart:math';
import 'dart:core';

import 'dart:typed_data';

class Utils {
  static final Random _random = Random.secure();

  static String createCryptoRandomString([int length = 32]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }

  static Uint8List generateRandomBytes([int length = 32]) {
    final values = List<int>.generate(length, (i) => _random.nextInt(256));
    return Uint8List.fromList(values);
  }

  static int createRandomSequence({int max = 20536}) {
    // 4294967296
    final random = Random();
    return random.nextInt(max).floor();
  }

  static List<int> convertStringToBytes(String message) {
    final List<int> bytes = utf8.encode(message);
    return bytes;
  }

  static String convertBytesToString(List<int> bytes) {
    final String message = utf8.decode(bytes);
    return message;
  }

  static int intsToByteHighAndLow(int highValue, int lowValue) =>
      ((highValue << 4) | lowValue) & 0xFF;

  static int highBitsToInt(int value) => (value & 0xFF) >> 4;
}
