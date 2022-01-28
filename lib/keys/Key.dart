import 'package:cryptography/cryptography.dart';

abstract class LibOMEMOKey {
  final int id;
  final KeyPair keyPair;

  const LibOMEMOKey({required this.id, required this.keyPair});
}
