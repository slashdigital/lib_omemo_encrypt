import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

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

const numOfPreKeysSample = 200;

final Axololt encryption = Axololt();

class ConversationSessionDefinition {
  final Session session;
  final SessionCipher sessionCipher;
  final SessionFactory sessionFactory;

  const ConversationSessionDefinition(
      {required this.session,
      required this.sessionCipher,
      required this.sessionFactory});
  ConversationSessionDefinition copyWith({
    Session? session,
    SessionCipher? sessionCipher,
    SessionFactory? sessionFactory,
  }) {
    return ConversationSessionDefinition(
        session: session ?? this.session,
        sessionCipher: sessionCipher ?? this.sessionCipher,
        sessionFactory: sessionFactory ?? this.sessionFactory);
  }
}

class ConversationSession {
  late SessionUser self;
  final friendSessions =
      SplayTreeMap<SessionMessaging, ConversationSessionDefinition>();
  late PreKeyPackage keyPackage;
  late MemoryStorage store;

  ConversationSession();
  ConversationSession.create(this.keyPackage, this.store);

  static Future<ConversationSession> loadFromBufferMap() async {
    throw UnimplementedError();
  }

  Future<Map<SessionMessaging, Uint8List>> writeToBufferMap() async {
    Map<SessionMessaging, Uint8List> bufferMaps = {};
    for (var key in friendSessions.keys) {
      final eachValue = friendSessions[key];
      bufferMaps[key] = await eachValue!.session.serialize();
    }
    return bufferMaps;
  }

  static Future<ConversationSession> createConversationSession(
      {required String name,
      required String deviceId,
      int numOfPreKeys = numOfPreKeysSample}) async {
    final keyPackage = await encryption.generatePreKeysPackage(numOfPreKeys);
    final _store = MemoryStorage(
      localRegistrationId: keyPackage.registrationId,
      localIdentityKeyPair: keyPackage.identityKeyPair,
    );

    _store.setLocalPreKeyPair(keyPackage.preKeys);
    _store.addLocalSignedPreKeyPair(SignedPreKeyPair.create(
      signedPreKeyId: keyPackage.signedPreKeyPairId,
      key: keyPackage.signedPreKeyPair.keyPair,
    ));

    final chatUser = ConversationSession.create(keyPackage, _store);
    chatUser.self = SessionUser(name: name, deviceId: deviceId);
    return chatUser;
  }

  SessionMessaging getSelfIdentifier() {
    return SessionMessaging.create(
        sessionUser: self,
        sessionGroup: null,
        sessionChatType: SessionChatType.personalChat);
  }

  bool checkFriendSessionSetup(SessionMessaging friendSession) {
    return friendSessions.containsKey(friendSession);
  }

  setupSession(SessionMessaging friendSession) {
    final SessionMessaging sessionMessagingOfFriend = friendSession;

    final _sessionFactory = SessionFactory(
        store: store, sessionMessagingIdentity: sessionMessagingOfFriend);
    Session _session = Session.create(sessionMessagingOfFriend);

    final _cipherSession = SessionCipher(sessionMessagingOfFriend);
    friendSessions.addEntries([
      MapEntry<SessionMessaging, ConversationSessionDefinition>(
          friendSession,
          ConversationSessionDefinition(
              session: _session,
              sessionCipher: _cipherSession,
              sessionFactory: _sessionFactory))
    ]);
    // friendSessions[friendSession] =
    //     (Tuple3<Session, SessionCipher, SessionFactory>(
    //         _session, _cipherSession, _sessionFactory));
    // friendSessionsSetup[friendSession] = true;
  }

  setupSessionFromPreKeyBundle(SessionMessaging friendSession,
      ReceivingPreKeyBundle receivingPreKeyBundle) async {
    final SessionMessaging sessionMessagingOfFriend = friendSession;

    final _sessionFactory = SessionFactory(
        store: store, sessionMessagingIdentity: sessionMessagingOfFriend);
    Session _session = await _sessionFactory
        .createSessionFromPreKeyBundle(receivingPreKeyBundle);

    final _cipherSession = SessionCipher(sessionMessagingOfFriend);
    friendSessions.addEntries([
      MapEntry<SessionMessaging, ConversationSessionDefinition>(
          friendSession,
          ConversationSessionDefinition(
              session: _session,
              sessionCipher: _cipherSession,
              sessionFactory: _sessionFactory))
    ]);
    // friendSessions[friendSession] =
    //     (Tuple3<Session, SessionCipher, SessionFactory>(
    //         _session, _cipherSession, _sessionFactory));
    // friendSessionsSetup[friendSession] = true;
  }

  PreKeyPair getPreKey(int index) {
    return keyPackage.preKeys[index];
  }

  // Normally server fetch for the other
  Future<ReceivingPreKeyBundle> givePreKeyBundleForFriend(int index) async {
    final receivingPreKeyPublic = await keyPackage.preKeys[index].preKey;
    // We need to rotate signed key periodically - daily etc..
    final signedPreKey = keyPackage.signedPreKeyPair;
    final receivingSignKey = signedPreKey;
    final receivingIdentityKey = keyPackage.identityKeyPair;
    final signature = keyPackage.signature;

    final receivingBundle = ReceivingPreKeyBundle(
        userId: '${self.name}-${self.deviceId}',
        identityKey: await receivingIdentityKey.identityKey,
        preKey: receivingPreKeyPublic,
        signedPreKey: await receivingSignKey.signedPreKey,
        signature: signature);
    if (kDebugMode) {
      print('====== Setup for');
      print('User: ${self.name}-${self.deviceId}');
      print('Ik: ${(await receivingBundle.identityKey.key.bytes)}');
      print('SPK: ${(await receivingBundle.signedPreKey!.key.bytes)}');
      print('SPKS: $signature');
    }
    return receivingBundle;
  }

  Future<EncryptedMessage> encryptMessageTo(
      SessionMessaging friendIdentifier, String message) async {
    final sessionDefinition = friendSessions[friendIdentifier]!;
    final encryptedMsg = await sessionDefinition.sessionCipher.encryptMessage(
        sessionDefinition.session, Utils.convertStringToBytes(message));

    final logMessage =
        '(${self.name} | Device: ${self.deviceId}): Send - $message';
    Log.instance.d(tag, logMessage);
    if (kDebugMode) {
      print(logMessage);
    }
    friendSessions.addEntries([
      MapEntry<SessionMessaging, ConversationSessionDefinition>(
          friendIdentifier,
          sessionDefinition.copyWith(
            session: encryptedMsg.session,
          ))
    ]);
    // friendSessions[friendIdentifier] =
    //     Tuple3<Session, SessionCipher, SessionFactory>(
    //         encryptedMsg.session, sessionGroup.item2, sessionGroup.item3);
    return encryptedMsg;
  }

  Future<DecryptedMessage> decryptMessageFrom(
      SessionMessaging friendIdentifier, EncryptedMessage encryptedMsg) async {
    // final sessionGroup = friendSessions[friendIdentifier]!;
    final sessionDefinition = friendSessions[friendIdentifier]!;
    if (encryptedMsg.isPreKeyWhisperMessage) {
      final _ciperSession = await sessionDefinition.sessionFactory
          .createSessionFromPreKeyWhisperMessage(
              sessionDefinition.session, encryptedMsg.body);
      final receiverSession = _ciperSession.session;

      final decrypedMessage = await sessionDefinition.sessionCipher
          .decryptPreKeyWhisperMessage(receiverSession, encryptedMsg.body);
      final message = utf8.decode(decrypedMessage.plainText);
      final logMessage =
          '(${self.name} | Device: ${self.deviceId}): Receive - $message  ';
      Log.instance.d(tag, logMessage);

      if (kDebugMode) {
        print(logMessage);
      }
      friendSessions.addEntries([
        MapEntry<SessionMessaging, ConversationSessionDefinition>(
            friendIdentifier,
            sessionDefinition.copyWith(
              session: decrypedMessage.session,
            ))
      ]);

      // friendSessions[friendIdentifier] =
      //     Tuple3<Session, SessionCipher, SessionFactory>(
      //         decrypedMessage.session, sessionGroup.item2, sessionGroup.item3);
      return decrypedMessage;
    } else {
      final decrypedMessage = await sessionDefinition.sessionCipher
          .decryptWhisperMessage(sessionDefinition.session, encryptedMsg.body);

      final message = utf8.decode(decrypedMessage.plainText);

      final logMessage =
          '(${self.name} | Device: ${self.deviceId}): Receive - $message  ';
      Log.instance.d(tag, logMessage);

      if (kDebugMode) {
        print(logMessage);
      }

      friendSessions.addEntries([
        MapEntry<SessionMessaging, ConversationSessionDefinition>(
            friendIdentifier,
            sessionDefinition.copyWith(
              session: decrypedMessage.session,
            ))
      ]);

      // friendSessions[friendIdentifier] =
      //     Tuple3<Session, SessionCipher, SessionFactory>(
      //         decrypedMessage.session, sessionGroup.item2, sessionGroup.item3);
      return decrypedMessage;
    }
  }
}
