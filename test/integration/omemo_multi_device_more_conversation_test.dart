import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/messages/omemo_message.dart';
import 'package:lib_omemo_encrypt/sessions/session_group.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';
import 'package:tuple/tuple.dart';
import 'chat_user.dart';
import 'conversation.dart';

void main() {
  const tag = 'Axololt';

  late ConversationPerson alice;
  late ConversationPerson bob;
  late ConversationPerson tom;
  late ConversationPerson jerry;
  late Conversation dmAliceBob;
  late Conversation gpParties;
  setUp(() async {
    alice = await ConversationPerson.init(Person.alice.name,
        personDevices[Person.alice]!.map<String>((e) => e.name).toList());
    bob = await ConversationPerson.init(Person.bob.name,
        personDevices[Person.bob]!.map<String>((e) => e.name).toList());
    tom = await ConversationPerson.init(Person.tom.name,
        personDevices[Person.tom]!.map<String>((e) => e.name).toList());
    jerry = await ConversationPerson.init(Person.jerry.name,
        personDevices[Person.jerry]!.map<String>((e) => e.name).toList());

    dmAliceBob = Conversation.createPerson([alice, bob]);
    gpParties = Conversation.createPerson([alice, bob, jerry, tom]);

    // aliceApp = await ChatUser.createChat(name: 'Alice', deviceId: '1');
    // aliceAppSecondDevice =
    //     await ChatUser.createChat(name: 'Alice', deviceId: '2');
    // bobApp = await ChatUser.createChat(name: 'Bob', deviceId: '3');
    // bobAppSecondDevice = await ChatUser.createChat(name: 'Bob', deviceId: '4');
  });
  test(
      'should fully encrypt and decrypt from Alice to one of her device and to Bob and his other device',
      () async {
    // Alice want to chat to Bob from Device "C"
    // She get id from her bob public prekey

    int counter = 5;
    bool finalResult = true;
    while (counter > 0) {
      counter--;

      int randomSender = Utils.createRandomSequence(max: 2);
      final Person person = personDevices.keys.elementAt(randomSender);
      final Iterable<Device> devices = personDevices[person]!;
      int randomDevice = Utils.createRandomSequence(max: devices.length);
      Device device = devices.elementAt(randomDevice);

      await dmAliceBob.setup(person.name, device.name,
          sender: counter == 5, offsetKey: counter * 3);

      final message =
          messages.elementAt(Utils.createRandomSequence(max: messages.length));

      final distributedMessage = await dmAliceBob.encryptMessageToOthers(
          person.name, device.name, message);
      final result = await dmAliceBob.decryptDistributedMessageOfTarget(
          person.name, device.name, message, distributedMessage);
      finalResult = finalResult && result;
    }
    expect(finalResult, true);
  });
}
