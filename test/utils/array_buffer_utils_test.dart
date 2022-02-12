import 'dart:convert';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/utils/array_buffer_utils.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

Function eq = const ListEquality().equals;
void main() {
  const message1 = "I love secure";

  const message2 = "I love end to end encryption";

  setUpAll(() async {});
  setUp(() {});
  group('Utils/array_buffer_utils', () {
    test('Should concat two byte buffer and able to decode to the same string',
        () async {
      final generated1 = Utils.convertStringToBytes(message1);
      final generated2 = Utils.convertStringToBytes(message2);

      final generatedText = ArrayBufferUtils.concat([
        Uint8List.fromList(generated1).buffer,
        Uint8List.fromList(generated2).buffer
      ]);
      expect(utf8.decode(generatedText), '$message1$message2');
    });
    test('Should be able to create buffer from list', () async {
      final generated1 = Utils.convertStringToBytes(message1);
      final generatedValue = ArrayBufferUtils.getBuffer(generated1);
      expect(generatedValue.asUint8List(), generated1);
    });
    test('Should be able to get byte list from secret', () async {
      final secretData = SecretKeyData.random(length: 32).bytes;
      SecretKey key = SecretKey(secretData);
      final bytes = await ArrayBufferUtils.getBytesList(key);
      expect(eq(bytes, secretData), true);
    });
    test('Should be able to get byte buffer from secret', () async {
      final secretData = SecretKeyData.random(length: 32).bytes;
      SecretKey key = SecretKey(secretData);
      final byteBuffer = await ArrayBufferUtils.getBytesBuffer(key);
      expect(byteBuffer.lengthInBytes, secretData.length);
    });
  });

  group('Concat method', () {
    test('Should concat array of two buffers', () {
      ByteData bd1 = ByteData(4);
      bd1.setInt8(0, 1);
      bd1.setInt8(1, 2);
      bd1.setInt8(2, 3);
      bd1.setInt8(3, 4);

      ByteData bd2 = ByteData(4);
      bd2.setInt8(0, 5);
      bd2.setInt8(1, 6);
      bd2.setInt8(2, 7);
      bd2.setInt8(3, 8);

      final expected = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);

      final actual = ArrayBufferUtils.concat([bd1.buffer, bd2.buffer]);
      print(actual);
      expect(actual, expected);
    });

    test('Should concat arrays of different lengths correct', () {
      ByteData bd1 = ByteData(3);
      bd1.setInt8(0, 1);
      bd1.setInt8(1, 2);
      bd1.setInt8(2, 3);

      ByteData bd2 = ByteData(2);
      bd2.setInt8(0, 4);
      bd2.setInt8(1, 5);
      
      ByteData bd3 = ByteData(5);
      bd3.setInt8(0, 6);
      bd3.setInt8(1, 7);
      bd3.setInt8(2, 8);
      bd3.setInt8(3, 9);
      bd3.setInt8(4, 10);

      final expected = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

      final actual = ArrayBufferUtils.concat([bd1.buffer, bd2.buffer, bd3.buffer]);
      print(actual);
      expect(actual, expected);
    });

    test('Should concat arrays of different lengths correct', () {
      ByteData bd1 = ByteData(3);
      bd1.setInt8(0, 1);
      bd1.setInt8(1, 2);
      bd1.setInt8(2, 3);

      ByteData bd2 = ByteData(2);
      bd2.setInt8(0, 4);
      bd2.setInt8(1, 5);
      
      ByteData bd3 = ByteData(5);
      bd3.setInt8(0, 6);
      bd3.setInt8(1, 7);
      bd3.setInt8(2, 8);
      bd3.setInt8(3, 9);
      bd3.setInt8(4, 10);

      final expected = Uint8List.fromList([1, 2, 3, 6, 7, 8, 9, 10, 4, 5]);

      final actual = ArrayBufferUtils.concat([bd1.buffer, bd3.buffer, bd2.buffer]);
      print(actual);
      expect(actual, expected);
    });
  });
}
