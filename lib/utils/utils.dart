import 'dart:convert';
import 'dart:math';
import 'dart:core';

import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

class Utils {
  static final Random _random = Random.secure();

  // Would the code read cleaner if the methods in this class were named 
  // 'cryptoRandomString' instead of createCryptoRandomString
  // or randomBytes() instead of generateRandomBytes(), or 
  // stringToBytes instead of convertStringToBytes?
  // Not sure... Just a thought.
  
  static String createCryptoRandomString([int length = 32]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    //If the correct length is required the I think this
    // return base64Url.encode(values).substring(0, length);
    //will do better, but then the original bytes can not be decoded again.
    return base64Url.encode(values);
  }

  static Uint8List generateRandomBytes([int length = 32]) {
    final values = List<int>.generate(length, (i) => _random.nextInt(256));
    return Uint8List.fromList(values);
  }

  static int createRandomSequence({int max = 20536}) {
    // 4294967296
    final random = Random(); 
    
    //Why not use _random.nextInt(max)
    //Why floor() ? 
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

  static KeyPairType keyPairTypeFromName(final String keyPairName) {
    if (keyPairName == KeyPairType.x25519.name) {
      return KeyPairType.x25519;
    } else if (keyPairName == KeyPairType.ed25519.name) {
      return KeyPairType.ed25519;
    } else {
      throw Exception('Unsupported keypair for this library');
    }
  }
}
