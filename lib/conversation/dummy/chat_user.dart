import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lib_omemo_encrypt/encryptions/axolotl/axolotl.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/session_cipher.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/session_factory.dart';
import 'package:lib_omemo_encrypt/keys/bundle/prekey_package.dart';
import 'package:lib_omemo_encrypt/keys/bundle/receiving_prekey_bundle.dart';
import 'package:lib_omemo_encrypt/keys/whisper/prekey.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';
import 'package:lib_omemo_encrypt/messages/omemo_message.dart';
import 'package:lib_omemo_encrypt/sessions/session.dart';
import 'package:lib_omemo_encrypt/sessions/session_messaging.dart';
import 'package:lib_omemo_encrypt/sessions/session_user.dart';
import 'package:lib_omemo_encrypt/storage/in-memory/memory_storage.dart';
import 'package:lib_omemo_encrypt/utils/log.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';
import 'package:tuple/tuple.dart';

const preKeys = 200;

final Axololt encryption = Axololt();

class ChatUser {
  late SessionUser self;
  Map<SessionMessaging, Tuple3<Session, SessionCipher, SessionFactory>>
      friendSessions = {};
  late PreKeyPackage keyPackage;
  late MemoryStorage store;
  Map<SessionMessaging, bool> friendSessionsSetup = {};
  // bool isSessionSetup = false;

  ChatUser();
  ChatUser.create(this.keyPackage, this.store);

  static Future<ChatUser> createChat(
      {required String name, required String deviceId}) async {
    final keyPackage = await encryption.generatePreKeysPackage(preKeys);
    final _store = MemoryStorage(
      localRegistrationId: keyPackage.registrationId,
      localIdentityKeyPair: keyPackage.identityKeyPair,
    );

    _store.setLocalPreKeyPair(keyPackage.preKeys);
    _store.addLocalSignedPreKeyPair(SignedPreKeyPair.create(
      signedPreKeyId: keyPackage.signedPreKeyPairId,
      key: keyPackage.signedPreKeyPair.keyPair,
    ));

    final chatUser = ChatUser.create(keyPackage, _store);
    chatUser.self = SessionUser(name: name, deviceId: deviceId);
    return chatUser;
  }

  SessionMessaging getSelfIdentifier() {
    return SessionMessaging.create(
        sessionUser: self,
        sessionGroup: null,
        sessionChatType: SessionChatType.personalChat);
  }

  setupSession(SessionMessaging friendSession) {
    final SessionMessaging sessionMessagingOfFriend = friendSession;

    final _sessionFactory = SessionFactory(
        store: store, sessionMessagingIdentity: sessionMessagingOfFriend);
    Session _session = Session.create(sessionMessagingOfFriend);

    final _cipherSession = SessionCipher(sessionMessagingOfFriend);
    friendSessions[friendSession] =
        (Tuple3<Session, SessionCipher, SessionFactory>(
            _session, _cipherSession, _sessionFactory));
    friendSessionsSetup[friendSession] = true;
  }

  setupSessionFromPreKeyBundle(SessionMessaging friendSession,
      ReceivingPreKeyBundle receivingPreKeyBundle) async {
    final SessionMessaging sessionMessagingOfFriend = friendSession;

    final _sessionFactory = SessionFactory(
        store: store, sessionMessagingIdentity: sessionMessagingOfFriend);
    Session _session = await _sessionFactory
        .createSessionFromPreKeyBundle(receivingPreKeyBundle);

    final _cipherSession = SessionCipher(sessionMessagingOfFriend);
    friendSessions[friendSession] =
        (Tuple3<Session, SessionCipher, SessionFactory>(
            _session, _cipherSession, _sessionFactory));
    friendSessionsSetup[friendSession] = true;
  }

  PreKeyPair getPreKey(int index) {
    return keyPackage.preKeys[index];
  }

  // Normally server fetch for the other
  Future<ReceivingPreKeyBundle> givePreKeyBundleForFriend(int index) async {
    final receivingPreKeyPublic = await keyPackage.preKeys[index].preKey;
    // Give new signed key for new people?
    final signedPreKey =
        await encryption.generateSignedPreKey(receivingPreKeyPublic.preKeyId);
    final newSignedKey = SignedPreKeyPair.create(
      signedPreKeyId: signedPreKey.signedPreKeyId,
      key: signedPreKey.keyPair,
    );
    final receivingSignKey = newSignedKey;
    final receivingIdentityKey = keyPackage.identityKeyPair;
    final signature =
        await encryption.generateSignature(receivingIdentityKey, signedPreKey);

    store.addLocalSignedPreKeyPair(newSignedKey);

    final receivingBundle = ReceivingPreKeyBundle(
        userId: '${self.name}-${self.deviceId}',
        identityKey: await receivingIdentityKey.identityKey,
        preKey: receivingPreKeyPublic,
        signedPreKey: await receivingSignKey.signedPreKey,
        signature: signature);
    return receivingBundle;
  }

  Future<EncryptedMessage> encryptMessageTo(
      SessionMessaging friendIdentifier, String message) async {
    final sessionGroup = friendSessions[friendIdentifier]!;
    final encryptedMsg = await sessionGroup.item2.encryptMessage(
        sessionGroup.item1, Utils.convertStringToBytes(message));

    final logMessage =
        '(${self.name} | Device: ${self.deviceId}): Send - $message';
    Log.instance.d(tag, logMessage);
    if (kDebugMode) {
      print(logMessage);
    }
    friendSessions[friendIdentifier] =
        Tuple3<Session, SessionCipher, SessionFactory>(
            encryptedMsg.session, sessionGroup.item2, sessionGroup.item3);
    return encryptedMsg;
  }

  Future<DecryptedMessage> decryptMessageFrom(
      SessionMessaging friendIdentifier, EncryptedMessage encryptedMsg) async {
    final sessionGroup = friendSessions[friendIdentifier]!;
    if (encryptedMsg.isPreKeyWhisperMessage) {
      final _ciperSession = await sessionGroup.item3
          .createSessionFromPreKeyWhisperMessage(
              sessionGroup.item1, encryptedMsg.body);
      final receiverSession = _ciperSession.session;

      final decrypedMessage = await sessionGroup.item2
          .decryptPreKeyWhisperMessage(receiverSession, encryptedMsg.body);
      final message = utf8.decode(decrypedMessage.plainText);
      final logMessage =
          '(${self.name} | Device: ${self.deviceId}): Receive - $message  ';
      Log.instance.d(tag, logMessage);

      if (kDebugMode) {
        print(logMessage);
      }

      friendSessions[friendIdentifier] =
          Tuple3<Session, SessionCipher, SessionFactory>(
              decrypedMessage.session, sessionGroup.item2, sessionGroup.item3);
      return decrypedMessage;
    } else {
      final decrypedMessage = await sessionGroup.item2
          .decryptWhisperMessage(sessionGroup.item1, encryptedMsg.body);

      final message = utf8.decode(decrypedMessage.plainText);

      final logMessage =
          '(${self.name} | Device: ${self.deviceId}): Receive - $message  ';
      Log.instance.d(tag, logMessage);

      if (kDebugMode) {
        print(logMessage);
      }

      friendSessions[friendIdentifier] =
          Tuple3<Session, SessionCipher, SessionFactory>(
              decrypedMessage.session, sessionGroup.item2, sessionGroup.item3);
      return decrypedMessage;
    }
  }
}
