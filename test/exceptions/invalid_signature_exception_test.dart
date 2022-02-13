import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/exceptions/invalid_signature_exception.dart';

main() {
  test('Message should be correctly prefixed', () {
    const message = 'A message';
    final exception = InvalidSignatureException(message);
    const expected = 'InvalidSignatureException - $message';
    
    expect(exception.toString(), expected);
  });
}
