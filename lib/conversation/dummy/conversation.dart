import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lib_omemo_encrypt/conversation/dummy/conversation_enum_dummy.dart';
import 'package:lib_omemo_encrypt/conversation/dummy/conversation_person.dart';
import 'package:lib_omemo_encrypt/conversation/dummy/conversation_session.dart';
import 'package:lib_omemo_encrypt/messages/omemo_message.dart';
import 'package:lib_omemo_encrypt/sessions/session_group.dart';
import 'package:tuple/tuple.dart';

Map<Person, Iterable<Device>> personDevices = {
  Person.bob: [Device.A, Device.B],
  Person.alice: [Device.C, Device.D],
  Person.tom: [Device.E, Device.F],
  Person.jerry: [Device.G, Device.H, Device.I],
};

class Conversation {
  late bool isGroup;
  late SessionGroup? sessionGroup;
  List<ConversationPerson> peopleParties = [];

  Conversation();

  Conversation.createGroup(this.peopleParties, this.sessionGroup) {
    isGroup = true;
  }
  Conversation.createPerson(this.peopleParties) {
    isGroup = false;
    sessionGroup = null;
  }

  updateState(ConversationSession instance) {
    int index = peopleParties
        .indexWhere((element) => element.personName == instance.self.name);
    if (index != -1) {
      int indexInstance = peopleParties[index].appInstances.indexWhere(
          (element) => element.self.deviceId == instance.self.deviceId);
      peopleParties[index].appInstances[indexInstance] = instance;
    }
  }

  Tuple2<ConversationSession, List<ConversationSession>> retrieveChatInstances(
      String yourName, String yourCurrentDeviceId) {
    final yourConversation =
        peopleParties.firstWhere((element) => element.personName == yourName);
    ConversationSession yourCurrentDeviceInstance = yourConversation
        .appInstances
        .firstWhere((element) => element.self.deviceId == yourCurrentDeviceId);
    List<ConversationSession> yourOtherDeviceInstances = yourConversation
        .appInstances
        .where((element) => element.self.deviceId != yourCurrentDeviceId)
        .toList();

    List<ConversationPerson> yourFriendConversations = peopleParties
        .where((element) => element.personName != yourName)
        .toList();

    List<ConversationSession> yourFriendInstances = [];

    for (var yourFriendConversation in yourFriendConversations) {
      yourFriendInstances =
          yourFriendInstances + yourFriendConversation.appInstances;
    }

    List<ConversationSession> otherParties =
        yourOtherDeviceInstances + yourFriendInstances;

    return Tuple2<ConversationSession, List<ConversationSession>>(
        yourCurrentDeviceInstance, otherParties);
  }

  Future<void> setup(String yourName, String yourCurrentDeviceId,
      {int offsetKey = 0}) async {
    int _offsetKey = offsetKey;
    final result = retrieveChatInstances(yourName, yourCurrentDeviceId);

    if (kDebugMode) {
      print(
          '========================================== Send To ${result.item2.map((e) => e.self.toString()).join(', ')}');
    }
    final yourCurrentDeviceInstance = result.item1;

    for (var otherInstance in result.item2) {
      if (!yourCurrentDeviceInstance
          .checkFriendSessionSetup(otherInstance.getSelfIdentifier())) {
        final receivingBundle =
            await otherInstance.givePreKeyBundleForFriend(_offsetKey);
        if (kDebugMode) {
          print('Output from func: ${receivingBundle.signature}');
        }
        await yourCurrentDeviceInstance.setupSessionFromPreKeyBundle(
            otherInstance.getSelfIdentifier(), receivingBundle);
        updateState(yourCurrentDeviceInstance);
        _offsetKey++;
      }
    }
  }

  Future<List<Tuple2<ConversationSession, EncryptedMessage>>>
      encryptMessageToOthers(
          String yourName, String yourCurrentDeviceId, String message) async {
    final result = retrieveChatInstances(yourName, yourCurrentDeviceId);
    final yourCurrentDeviceInstance = result.item1;

    List<Tuple2<ConversationSession, EncryptedMessage>>
        distributedEncryptedMessages = [];
    for (var otherInstance in result.item2) {
      final encryptedMessage = await yourCurrentDeviceInstance.encryptMessageTo(
          otherInstance.getSelfIdentifier(),
          message.replaceAll('{name}', otherInstance.self.name));

      distributedEncryptedMessages.add(
          Tuple2<ConversationSession, EncryptedMessage>(
              otherInstance, encryptedMessage));
      updateState(yourCurrentDeviceInstance);
    }
    return distributedEncryptedMessages;
  }

  Future<bool> decryptDistributedMessageOfTarget(
      String yourName,
      String yourCurrentDeviceId,
      String originalMessage,
      List<Tuple2<ConversationSession, EncryptedMessage>>
          distributedEncryptedMessages) async {
    final result = retrieveChatInstances(yourName, yourCurrentDeviceId);
    final senderSession = result.item1;
    bool matched = true;
    for (var distributedEncryptedMessage in distributedEncryptedMessages) {
      final receiverInstance = distributedEncryptedMessage.item1;
      final encryptedMessage = distributedEncryptedMessage.item2;
      if (!receiverInstance
          .checkFriendSessionSetup(senderSession.getSelfIdentifier())) {
        receiverInstance.setupSession(senderSession.getSelfIdentifier());
      }
      final decryptedMessage = await receiverInstance.decryptMessageFrom(
          senderSession.getSelfIdentifier(), encryptedMessage);
      matched =
          matched && utf8.decode(decryptedMessage.plainText) == originalMessage;
      updateState(receiverInstance);
    }
    return matched;
  }
}
