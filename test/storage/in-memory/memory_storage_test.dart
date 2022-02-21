import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/encryptions/axolotl/axolotl.dart';
import 'package:lib_omemo_encrypt/storage/in-memory/memory_storage.dart';

const countPreKeys = 20;

void main() async {
  final Axololt axololt = Axololt();
  final registrationId = axololt.generateRegistrationId();
  final identityKeyPair = await axololt.generateIdentityKeyPair();
  final inMemoryStorage = MemoryStorage(
    localRegistrationId: registrationId,
    localIdentityKeyPair: identityKeyPair,
  );
  group('storage/in-memory', () {
    test('should get the local registration id', () async {
      expect(await inMemoryStorage.getLocalRegistrationId(), registrationId);
    });
    test('should get the local identity key pair id', () async {
      expect(await inMemoryStorage.getLocalIdentityKeyPair(), identityKeyPair);
    });
  });
}
