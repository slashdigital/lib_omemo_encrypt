import 'dart:async';
import 'dart:convert';

import 'package:lib_omemo_encrypt/messages/omemo_message.dart';
import 'package:lib_omemo_encrypt/sessions/session_group.dart';
import 'package:tuple/tuple.dart';

import 'chat_user.dart';

const Iterable<String> messages = [
  'Hi!',
  'How are you?',
  'Do you know this code?',
  'Could you help me fix?',
  'I don\'t understand',
  'Got it!',
  'xD',
  'I like it',
  'Do you have time later?'
];

const preKeys = 200;
enum Person {
  bob,
  alice,
  tom,
  jerry,
}

enum Device { A, B, C, D, E, F, G, H, I }

Map<Person, Iterable<Device>> personDevices = {
  Person.bob: [Device.A, Device.B],
  Person.alice: [Device.C, Device.D],
  Person.tom: [Device.E, Device.F],
  Person.jerry: [Device.G, Device.H, Device.I],
};

class ConversationPerson {
  final String personName;
  List<ChatUser> appInstances = [];

  ConversationPerson(this.personName);

  static Future<ConversationPerson> init(
      String name, List<String> deviceIds) async {
    final conversation = ConversationPerson(name);
    final List<ChatUser> chatUsers = [];
    for (var element in deviceIds) {
      chatUsers.add(await ChatUser.createChat(name: name, deviceId: element));
    }

    conversation.appInstances = chatUsers;
    return conversation;
  }
}

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

  updateState(ChatUser instance) {
    int index = peopleParties
        .indexWhere((element) => element.personName == instance.self.name);
    if (index != -1) {
      int indexInstance = peopleParties[index].appInstances.indexWhere(
          (element) => element.self.deviceId == instance.self.deviceId);
      peopleParties[index].appInstances[indexInstance] = instance;
    }
  }

  Tuple2<ChatUser, List<ChatUser>> retrieveChatInstances(
      String yourName, String yourCurrentDeviceId) {
    final yourConversation =
        peopleParties.firstWhere((element) => element.personName == yourName);
    ChatUser yourCurrentDeviceInstance = yourConversation.appInstances
        .firstWhere((element) => element.self.deviceId == yourCurrentDeviceId);
    List<ChatUser> yourOtherDeviceInstances = yourConversation.appInstances
        .where((element) => element.self.deviceId != yourCurrentDeviceId)
        .toList();

    List<ConversationPerson> yourFriendConversations = peopleParties
        .where((element) => element.personName != yourName)
        .toList();

    List<ChatUser> yourFriendInstances = [];

    for (var yourFriendConversation in yourFriendConversations) {
      yourFriendInstances =
          yourFriendInstances + yourFriendConversation.appInstances;
    }

    List<ChatUser> otherParties =
        yourOtherDeviceInstances + yourFriendInstances;

    return Tuple2<ChatUser, List<ChatUser>>(
        yourCurrentDeviceInstance, otherParties);
  }

  Future<void> setup(String yourName, String yourCurrentDeviceId,
      {int offsetKey = 0, bool sender = false}) async {
    int _offsetKey = offsetKey;
    final result = retrieveChatInstances(yourName, yourCurrentDeviceId);
    final yourCurrentDeviceInstance = result.item1;

    for (var otherInstance in result.item2) {
      if (!yourCurrentDeviceInstance.friendSessionsSetup
              .containsKey(otherInstance.getSelfIdentifier()) ||
          !yourCurrentDeviceInstance
              .friendSessionsSetup[otherInstance.getSelfIdentifier()]!) {
        await yourCurrentDeviceInstance.setupSessionFromPreKeyBundle(
            otherInstance.getSelfIdentifier(),
            await otherInstance.givePreKeyBundleForFriend(_offsetKey));
        updateState(yourCurrentDeviceInstance);
        _offsetKey++;
      }
    }
  }

  Future<List<Tuple2<ChatUser, EncryptedMessage>>> encryptMessageToOthers(
      String yourName, String yourCurrentDeviceId, String message) async {
    final result = retrieveChatInstances(yourName, yourCurrentDeviceId);
    final yourCurrentDeviceInstance = result.item1;

    List<Tuple2<ChatUser, EncryptedMessage>> distributedEncryptedMessages = [];
    for (var otherInstance in result.item2) {
      final encryptedMessage = await yourCurrentDeviceInstance.encryptMessageTo(
          otherInstance.getSelfIdentifier(),
          message.replaceAll('{name}', otherInstance.self.name));

      distributedEncryptedMessages.add(
          Tuple2<ChatUser, EncryptedMessage>(otherInstance, encryptedMessage));
      updateState(yourCurrentDeviceInstance);
    }
    return distributedEncryptedMessages;
  }

  Future<bool> decryptDistributedMessageOfTarget(
      String yourName,
      String yourCurrentDeviceId,
      String originalMessage,
      List<Tuple2<ChatUser, EncryptedMessage>>
          distributedEncryptedMessages) async {
    final result = retrieveChatInstances(yourName, yourCurrentDeviceId);
    final senderSession = result.item1;
    bool matched = true;
    for (var distributedEncryptedMessage in distributedEncryptedMessages) {
      final receiverInstance = distributedEncryptedMessage.item1;
      final encryptedMessage = distributedEncryptedMessage.item2;
      if (!receiverInstance.friendSessionsSetup
              .containsKey(senderSession.getSelfIdentifier()) ||
          !receiverInstance
              .friendSessionsSetup[senderSession.getSelfIdentifier()]!) {
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
