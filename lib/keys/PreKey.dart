import 'package:lib_omemo_encrypt/keys/key.dart';

class PreKey extends LibOMEMOKey {
  const PreKey({required id, required keyPair})
      : super(id: id, keyPair: keyPair);
}
