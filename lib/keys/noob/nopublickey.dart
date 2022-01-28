import 'package:cryptography/cryptography.dart';

class NoPublicKey extends PublicKey {
  @override
  KeyPairType<KeyPairData, PublicKey> get type => throw UnimplementedError();
}
