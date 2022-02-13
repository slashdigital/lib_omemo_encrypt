import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/exceptions/invalid_key_exception.dart';

main() {
  test('Message should be correctly prefixed', () {
    const message = 'A message';
    final exception = InvalidKeyException(message);
    const expected = 'InvalidKeyException - $message';
    
    expect(exception.toString(), expected);
  });
}