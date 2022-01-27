import 'package:lib_omemo_encrypt/exceptions/prekey_exception.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_bundle.dart';

class PreKeyBundleManager {
  final Map<String, PreKeyBundle> userPrekeyBundles = {};

  PreKeyBundleManager();

  setPreKey(String userId, PreKeyBundle preKeyBundle) {
    if (!userPrekeyBundles.containsKey(userId)) {
      userPrekeyBundles[userId] = preKeyBundle;
    } else {
      throw PreKeyException();
    }
  }

  getPreKey(String userId) {
    if (userPrekeyBundles.containsKey(userId)) {
      return userPrekeyBundles[userId];
    } else {
      throw PreKeyException();
    }
  }
}
