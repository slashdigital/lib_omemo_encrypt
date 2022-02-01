import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

void main() {
  setUpAll(() async {});
  setUp(() {});
  group('Utils/utils', () {
    test('Should create random secure string 32 length', () async {
      final generatedText = Utils.createCryptoRandomString(32);
      final bareString = base64Url.decode(generatedText);
      expect(bareString.length, 32);
    });
    test('Should create random secure string 16 length', () async {
      final generatedText = Utils.createCryptoRandomString(16);
      final bareString = base64Url.decode(generatedText);
      expect(bareString.length, 16);
    });
    test('Should create random secure string 8 length', () async {
      final generatedText = Utils.createCryptoRandomString(8);
      final bareString = base64Url.decode(generatedText);
      expect(bareString.length, 8);
    });
    test('Should create random sequence', () async {
      final generatedValue = Utils.createRandomSequence(max: 2024);
      expect(generatedValue.runtimeType, int);
      expect(generatedValue < 2024, true);
    });
    test('Should convert string to bytes', () async {
      const message = "I love secure";
      final generatedValue = Utils.convertStringToBytes(message);
      expect(generatedValue,
          [73, 32, 108, 111, 118, 101, 32, 115, 101, 99, 117, 114, 101]);
      expect(utf8.decode(generatedValue), message);
    });
  });
}
