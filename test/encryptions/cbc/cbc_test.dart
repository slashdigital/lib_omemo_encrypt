import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/encryptions/cbc/cbc.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

void main() {
  group('encryptions/cbc.dart', () {
    test('Should pad the string', () async {
      final byteString = Utils.convertStringToBytes('Hello World!');
      final paddedString = pad(Uint8List.fromList(byteString), 16);
      final unpaddedString = unpad(paddedString);
      expect(unpaddedString, byteString);
    });
  });
}
