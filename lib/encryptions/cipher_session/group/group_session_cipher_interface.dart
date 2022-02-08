import 'dart:typed_data';

import 'package:lib_omemo_encrypt/encryptions/cipher_session/group/group_key_state.dart';

abstract class GroupSessionCipherInterface {
  encrypt(Uint8List paddedMessage);
  decrypt(Uint8List senderKeyMessageBytes);
  getSenderKey(SenderKeyState senderKeyState, int iteration);
}
