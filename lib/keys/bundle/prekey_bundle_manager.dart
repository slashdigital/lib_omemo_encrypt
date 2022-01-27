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

  PreKeyBundle getPreKey(String userId) {
    if (userPrekeyBundles.containsKey(userId)) {
      final index = userPrekeyBundles.keys
          .toList()
          .indexWhere((element) => element == userId);
      return userPrekeyBundles.values.elementAt(index);
    } else {
      throw PreKeyException();
    }
  }
}
