import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/conversation/dummy/conversation_enum_dummy.dart';
import 'package:lib_omemo_encrypt/conversation/dummy/conversation_person.dart';
import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';
import 'package:lib_omemo_encrypt/sessions/session_group.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';
import 'package:lib_omemo_encrypt/conversation/dummy/conversation.dart';

void main() {
  late ConversationPerson alice;
  late ConversationPerson bob;
  late ConversationPerson tom;
  late ConversationPerson jerry;
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

    // gpParties = Conversation.createGroup([alice, bob, jerry, tom], const SessionGroup(groupName: 'Team Party', groupId: 'team-party', sender: SessionUser(name: 'Owner', deviceId: 'Device 1')));
    gpParties = Conversation.createGroup(
        [alice, bob, jerry, tom],
        SessionGroup(
            groupName: 'Team Party',
            groupId: 'team-party',
            sender: alice.appInstances[0].self));
  });
  test(
      'should fully encrypt and decrypt from Alice group to one of her device and to her group member parties',
      () async {
    // Alice want to chat to Bob from Device "C"
    // She get id from her bob public prekey

    int max = 10;
    int counter = max;
    bool finalResult = true;
    while (counter > 0) {
      counter--;

      int randomSender =
          Utils.createRandomSequence(max: personDevices.keys.length);
      final Person person = personDevices.keys.elementAt(randomSender);
      final Iterable<Device> devices = personDevices[person]!;
      int randomDevice = Utils.createRandomSequence(max: devices.length);
      Device device = devices.elementAt(randomDevice);

      await gpParties.setup(person.name, device.name,
          sender: counter == 5, offsetKey: counter * 10);

      final message =
          messages.elementAt(Utils.createRandomSequence(max: messages.length));
      if (kDebugMode) {
        print(
            '================== Message Counter ${max - counter} ==================');
      }
      final distributedMessage = await gpParties.encryptMessageToOthers(
          person.name, device.name, message);
      final result = await gpParties.decryptDistributedMessageOfTarget(
          person.name, device.name, message, distributedMessage);
      finalResult = finalResult && result;
    }
    expect(finalResult, true);
  });
}
