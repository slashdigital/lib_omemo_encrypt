import 'package:lib_omemo_encrypt/kdf/hkdf/hkdf.dart';

class HKDFv3 extends HKDF {
  @override
  int getIterationStartOffset() => 1;
}
