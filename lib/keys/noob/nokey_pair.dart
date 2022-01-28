import 'package:cryptography/cryptography.dart';

class NoKeyPair extends KeyPair {
  @override
  Future<KeyPairData> extract() {
    throw UnimplementedError();
  }
}
