import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/conversation/dummy/conversation_session.dart';

const preKeys = 20;
enum Person {
  bob,
  alice,
}

void main() {
  late ConversationSession aliceApp;
  late ConversationSession aliceAppSecondDevice;

  late ConversationSession bobApp;
  late ConversationSession bobAppSecondDevice;
  setUp(() async {
    aliceApp = await ConversationSession.createConversationSession(
        name: 'Alice', deviceId: '1');
    aliceAppSecondDevice = await ConversationSession.createConversationSession(
        name: 'Alice', deviceId: '2');
    bobApp = await ConversationSession.createConversationSession(
        name: 'Bob', deviceId: '3');
    bobAppSecondDevice = await ConversationSession.createConversationSession(
        name: 'Bob', deviceId: '4');
  });
  test(
      'should fully encrypt and decrypt from Alice to one of her device and to Bob and his other device',
      () async {
    // Alice want to chat to Bob
    // She get id from her bob public prekey
    await aliceApp.setupSessionFromPreKeyBundle(
        bobApp.getSelfIdentifier(), await bobApp.givePreKeyBundleForFriend(0));
    // She get id from her bob public prekey other device
    await aliceApp.setupSessionFromPreKeyBundle(
        bobAppSecondDevice.getSelfIdentifier(),
        await bobAppSecondDevice.givePreKeyBundleForFriend(10));
    // And also send a copy to her device
    // She get id from her device public prekey
    await aliceApp.setupSessionFromPreKeyBundle(
        aliceAppSecondDevice.getSelfIdentifier(),
        await aliceAppSecondDevice.givePreKeyBundleForFriend(1));

    // Alice send encrypt message to both bob;
    final encryptedToBob = await aliceApp.encryptMessageTo(
        bobApp.getSelfIdentifier(), 'Hello Bob');
    final encryptedToBobOtherDevice = await aliceApp.encryptMessageTo(
        bobAppSecondDevice.getSelfIdentifier(), 'Hello Bob');
    final encryptedToHerDevice = await aliceApp.encryptMessageTo(
        aliceAppSecondDevice.getSelfIdentifier(), 'Hello Bob');

    // Bob try to decrypt message
    // Knowing he needs to chat to/from Alice, he setup placeholder session
    await bobApp.setupSession(aliceApp.getSelfIdentifier());
    final decryptedMessageFromAlice = await bobApp.decryptMessageFrom(
        aliceApp.getSelfIdentifier(), encryptedToBob);
    expect(utf8.decode(decryptedMessageFromAlice.plainText), 'Hello Bob');
    // The other device already receive the message - know by the device id attach in the xmpp element
    await bobAppSecondDevice.setupSession(aliceApp.getSelfIdentifier());
    final decryptedMessageFromAliceOnOtherDevice =
        await bobAppSecondDevice.decryptMessageFrom(
            aliceApp.getSelfIdentifier(), encryptedToBobOtherDevice);
    expect(utf8.decode(decryptedMessageFromAliceOnOtherDevice.plainText),
        'Hello Bob');
    // Alice device to try decrypt message
    // Knowing by receiving carbon copy message to this device, this device try to setup the placeholder session
    await aliceAppSecondDevice.setupSession(aliceApp.getSelfIdentifier());
    final decryptedMessageFromAliceDevice = await aliceAppSecondDevice
        .decryptMessageFrom(aliceApp.getSelfIdentifier(), encryptedToHerDevice);
    expect(utf8.decode(decryptedMessageFromAliceDevice.plainText), 'Hello Bob');
  });
}
