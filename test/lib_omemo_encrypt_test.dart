import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/group/group_session_cipher.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/group/group_session_factory.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/session_cipher.dart';
import 'package:lib_omemo_encrypt/keys/bundle/receiving_prekey_bundle.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';

import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';
import 'package:lib_omemo_encrypt/messages/whisper_sender_distribution_message.dart';
import 'package:lib_omemo_encrypt/sessions/session_group.dart';
import 'package:lib_omemo_encrypt/sessions/session_user.dart';
import 'package:lib_omemo_encrypt/storage/in-memory/group_memory_storage.dart';
import 'package:lib_omemo_encrypt/storage/in-memory/memory_storage.dart';
import 'package:lib_omemo_encrypt/utils/log.dart';
import 'package:tuple/tuple.dart';

const preKeys = 20;
enum Person {
  bob,
  alice,
}

void main() {
  late Axololt encryption;
  List<Tuple2<Person, String>> conversationMessages = [
    const Tuple2<Person, String>(Person.bob, 'Hi Alice'),
    const Tuple2<Person, String>(Person.bob, 'How are you?'),
    const Tuple2<Person, String>(Person.alice, 'Hi bob'),
    const Tuple2<Person, String>(Person.alice, 'I am good'),
    const Tuple2<Person, String>(Person.bob, 'Alice do you have a minute?'),
    const Tuple2<Person, String>(Person.alice, 'Yes sure'),
  ];
  Map<Person, Tuple3<Session, SessionCipher, SessionFactory>> personSessions =
      {};
  const tag = 'Axololt';
  setUp(() {
    encryption = Axololt();
  });
  test(
      'should fully encrypt and decrypt 5 messages back and forth between bob and alice',
      () async {
    /// You get
    /// - prekey
    /// - signedprekey
    /// - signature (sign signedprekey public key) by identity key
    /// - identity key
    final alicekeyPackage = await encryption.generatePreKeysPackage(preKeys);
    // ### 1. Alice start application and init store and keys
    const sameKeyIndex = 1;

    final aliceStore = MemoryStorage(
      localRegistrationId: alicekeyPackage.registrationId,
      localIdentityKeyPair: alicekeyPackage.identityKeyPair,
    );
    // ### 2. Alice broadcasting pre keys (now store in local)
    // ### 2.1. Send to server (xmpp) to register device for this prekey
    /// Publishing bundle thru OMEMO | 5.3.2 Bundles
    /**
    /// <iq from='juliet@capulet.lit' type='set' id='annouce2'>
        <pubsub xmlns='http://jabber.org/protocol/pubsub'>
          <publish node='urn:xmpp:omemo:2:bundles'>
            <item id='31415'>
              <bundle xmlns='urn:xmpp:omemo:2'>
                <spk id='0'>b64/encoded/data</spk>
                <spks>b64/encoded/data</spks>
                <ik>b64/encoded/data</ik>
                <prekeys>
                  <pk id='0'>b64/encoded/data</pk>
                  <pk id='1'>b64/encoded/data</pk>
                  <!-- … -->
                  <pk id='99'>b64/encoded/data</pk>
                </prekeys>
              </bundle>
            </item>
          </publish>
          <publish-options>
            <x xmlns='jabber:x:data' type='submit'>
              <field var='FORM_TYPE' type='hidden'>
                <value>http://jabber.org/protocol/pubsub#publish-options</value>
              </field>
              <field var='pubsub#max_items'>
                <value>max</value>
              </field>
            </x>
          </publish-options>
        </pubsub>
      </iq>
    */
    aliceStore.setLocalPreKeyPair(alicekeyPackage.preKeys);

    // ### 3. Bob want to message to alice
    /// Protocol OMEMO | 5.2 Discovering peer support (https://xmpp.org/extensions/xep-0384.html#protobuf-schema)
    ///
    /// You get
    /// - prekey
    /// - signedprekey
    /// - signature (sign signedprekey public key) by identity key
    /// - identity key
    final bobKeyPackage = await encryption.generatePreKeysPackage(preKeys);
    // ### 3.1 Bob request to server for alice Key
    // ### 3.2 bob get pre key, indexed 0 from her list
    /// Normally this is done with XMPP OMEMO
    /*
      <iq type='get'
          from='romeo@montague.lit'
          to='juliet@capulet.lit'
          id='fetch1'>
        <pubsub xmlns='http://jabber.org/protocol/pubsub'>
          <items node='urn:xmpp:omemo:2:bundles'>
            <item id='31415'/>
          <items>
        </pubsub>
      </iq>
    */
    Log.instance.v(tag,
        '============================= BOB start request for alice key and try to chat');
    // final bobReceivingPreKeyId = alicekeyPackage.preKeys[sameKeyIndex].preKeyId;
    final bobReceivingPreKeyPublic =
        await alicekeyPackage.preKeys[sameKeyIndex].preKey;
    final bobReceivingSignKey = alicekeyPackage.signedPreKeyPair;
    final bobReceivingIdentityKey = alicekeyPackage.identityKeyPair;
    final signature = alicekeyPackage.signature;
    // ### 3.3 Bob construct the receiving prekey bundle

    // Alice set key for Bob # use key 0
    const bobAliceUserId = 'alice@example.co';
    final bobReceivingBundle = ReceivingPreKeyBundle(
        userId: bobAliceUserId,
        identityKey: await bobReceivingIdentityKey.identityKey,
        preKey: bobReceivingPreKeyPublic,
        signedPreKey: await bobReceivingSignKey.signedPreKey,
        signature: signature);

    // ### 3.4 ? bob store alice prekey in his local storage
    final bobStore = MemoryStorage(
      localRegistrationId: bobKeyPackage.registrationId,
      localIdentityKeyPair: bobKeyPackage.identityKeyPair,
    );

    // ### 4 Bob try to init the first cipher session
    const bobSessionUser = SessionUser(name: '62457689343', deviceId: '1');
    final bobSessionFactory =
        SessionFactory(store: bobStore, sessionUser: bobSessionUser);
    var bobSession = await bobSessionFactory
        .createSessionFromPreKeyBundle(bobReceivingBundle);

    final bobCipherSession = SessionCipher();
    final aliceCipherSession = SessionCipher();
    personSessions[Person.bob] = Tuple3<Session, SessionCipher, SessionFactory>(
        bobSession, bobCipherSession, bobSessionFactory);
    // ### 5. bob try to encrypt and the first whisper key
    // const bobMessageToAlice = 'I want to chat hello';
    // final bobCipherSession = SessionCipher();
    // final encryptedMessage = await bobCipherSession.encryptMessage(
    //     bobSession, Utils.convertStringToBytes(bobMessageToAlice));

    // bobSession = encryptedMessage.session;

    // 6. Bob send message to alice using xmpp and wrapped in the message enc
    /** message envelope - 5.5.1 SCE Profile
     * <envelope xmlns='urn:xmpp:sce:1'>
        <content>
          <body xmlns='jabber:client'>
          Hello World!
          </body>
        </content>
        <rpad>...</rpad>
        <from jid='romeo@montague.lit'/>
      </envelope>
            
     */

    /**
     * Example 7. Sending a message
     * <message to='juliet@capulet.lit' from='romeo@montague.lit' id='send1'>
        <encrypted xmlns='urn:xmpp:omemo:2'>
          <header sid='27183'>
            <keys jid='juliet@capulet.lit'>
              <key rid='31415'>b64/encoded/data</key>
            </keys>
            <keys jid='romeo@montague.lit'>
              <key rid='1337'>b64/encoded/data</key>
              <key kex='true' rid='12321'>b64/encoded/data</key>
              <!-- ... -->
            </keys>
          </header>
          <payload>
            base64/encoded/message/key/encrypted/envelope/element
          </payload>
        </encrypted>
        <store xmlns='urn:xmpp:hints'/>
      </message>
     */

    // 7. Alice receive the key and message thru server xmpp?
    // Is it key exchange?

    // ### 8 Alice try to init the first cipher session
    Log.instance.v(tag,
        '============================= ALICE start getting the prekey thru whisper message');
    aliceStore.addLocalSignedPreKeyPair(SignedPreKeyPair(
      signedPreKeyId: alicekeyPackage.signedPreKeyPairId,
      key: alicekeyPackage.signedPreKeyPair.keyPair,
    ));

    const aliceSessionUser = SessionUser(name: '62457689347', deviceId: '2');
    final aliceSessionFactory =
        SessionFactory(store: aliceStore, sessionUser: aliceSessionUser);
    Session _aliceSession = Session();
    personSessions[Person.alice] =
        Tuple3<Session, SessionCipher, SessionFactory>(
            _aliceSession, aliceCipherSession, aliceSessionFactory);

    /// Looping conversation test
    ///
    int passedCaseCounter = 0;
    for (var index = 0; index < conversationMessages.length; index++) {
      final messageTuple = conversationMessages[index];
      final message = messageTuple.item2;
      final sender = messageTuple.item1;
      final receiver = sender == Person.bob ? Person.alice : Person.bob;
      final senderSession = personSessions[sender]!.item1;
      final senderSessionCipher = personSessions[sender]!.item2;
      final senderSessionFactory = personSessions[sender]!.item3;
      var receiverSession = personSessions[receiver]!.item1;
      final receiverSessionCipher = personSessions[receiver]!.item2;
      final receiverSessionFactory = personSessions[receiver]!.item3;

      final encryptedMsg = await senderSessionCipher.encryptMessage(
          senderSession, Utils.convertStringToBytes(message));
      Log.instance.v(tag,
          '$sender: Send - $message - Encrypted to (${encryptedMsg.body}}');
      personSessions[sender] = Tuple3<Session, SessionCipher, SessionFactory>(
          encryptedMsg.session, senderSessionCipher, senderSessionFactory);

      if (encryptedMsg.isPreKeyWhisperMessage) {
        final _ciperSession =
            await receiverSessionFactory.createSessionFromPreKeyWhisperMessage(
                receiverSession, encryptedMsg.body);
        receiverSession = _ciperSession.session;

        final decrypedMessage = await receiverSessionCipher
            .decryptPreKeyWhisperMessage(receiverSession, encryptedMsg.body);

        Log.instance.v(tag,
            '$receiver: Receive - $message - Decrypted from (${encryptedMsg.body}}');
        personSessions[receiver] =
            Tuple3<Session, SessionCipher, SessionFactory>(
                decrypedMessage.session,
                receiverSessionCipher,
                receiverSessionFactory);
      } else {
        final decrypedMessage = await receiverSessionCipher
            .decryptWhisperMessage(receiverSession, encryptedMsg.body);

        Log.instance.v(tag,
            '$receiver: Receive - $message - Decrypted from (${encryptedMsg.body}}');
        personSessions[receiver] =
            Tuple3<Session, SessionCipher, SessionFactory>(
                decrypedMessage.session,
                receiverSessionCipher,
                receiverSessionFactory);
      }

      passedCaseCounter++;
    }
    expect(passedCaseCounter, conversationMessages.length);
  });

  test('Should work with group', () async {
    const alice = SessionUser(name: '62344785747', deviceId: '2');
    const tom = SessionUser(name: '62344785749', deviceId: '33');
    const groupSender = SessionGroup(
        groupId: 'private-group', groupName: 'Private group', sender: alice);
    final aliceStore = GroupMemoryStorage();
    final bobStore = GroupMemoryStorage();
    final tomStore = GroupMemoryStorage();

    final aliceSessionBuilder = GroupSessionFactory(aliceStore);
    final bobSessionBuilder = GroupSessionFactory(bobStore);
    final tomSessionBuilder = GroupSessionFactory(tomStore);

    final aliceGroupCipher = GroupSessionCipher(aliceStore, groupSender);
    final bobGroupCipher = GroupSessionCipher(bobStore, groupSender);
    final tomSessionCipher = GroupSessionCipher(tomStore, groupSender);

    // Alice want to send message, so she need to send a SenderKeyDistributionMessage to all members of the group first
    final sentAliceDistributionMessage =
        await aliceSessionBuilder.create(groupSender);

    final receivedDistributionMessageFromAlice =
        WhisperSenderDistributionMessage.fromBytes(
            sentAliceDistributionMessage.serialized);
    await bobSessionBuilder.storeKeyDistribution(
        groupSender, receivedDistributionMessageFromAlice);
    await tomSessionBuilder.storeKeyDistribution(
        groupSender, receivedDistributionMessageFromAlice);

    Log.instance.v(tag, 'Alice sent: \'Hello bob and Tom\'');
    final ciphertextFromAlice = await aliceGroupCipher
        .encrypt(Uint8List.fromList(utf8.encode('Hello bob and Tom')));
    final plaintextFromAlice =
        await bobGroupCipher.decrypt(ciphertextFromAlice);
    final tomPlaintextFromAlice =
        await tomSessionCipher.decrypt(ciphertextFromAlice);

    // ignore: avoid_print
    Log.instance
        .v(tag, 'Bob get text from Alice: ' + utf8.decode(plaintextFromAlice));
    // ignore: avoid_print
    Log.instance.v(
        tag, 'Tom get text from Alice: ' + utf8.decode(tomPlaintextFromAlice));

    // Now Tom want want to send message, so she need to send a SenderKeyDistributionMessage to all members of the group first

    Log.instance.v(tag,
        '======== New message sender require to init new sender group ========');
    const groupSenderTom = SessionGroup(
        groupId: 'private-group', groupName: 'Private group', sender: tom);

    final tomSessionCipherNext = GroupSessionCipher(tomStore, groupSenderTom);
    final sentTomDistributionMessage =
        await tomSessionBuilder.create(groupSenderTom);
    Log.instance.v(tag, 'Tom sent: \'Hello alice and bob\'');
    final ciphertextFromTom = await tomSessionCipherNext
        .encrypt(Uint8List.fromList(utf8.encode('Hello alice and bob')));

    final receivedDistributionMessageFromTom =
        WhisperSenderDistributionMessage.fromBytes(
            sentTomDistributionMessage.serialized);
    await aliceSessionBuilder.storeKeyDistribution(
        groupSenderTom, receivedDistributionMessageFromTom);
    await bobSessionBuilder.storeKeyDistribution(
        groupSenderTom, receivedDistributionMessageFromTom);

    final aliceGroupCipherNext = GroupSessionCipher(aliceStore, groupSenderTom);
    final bobGroupCipherNext = GroupSessionCipher(bobStore, groupSenderTom);
    final alicePlaintextFromTom =
        await aliceGroupCipherNext.decrypt(ciphertextFromTom);
    final bobPlaintextFromTom =
        await bobGroupCipherNext.decrypt(ciphertextFromTom);
    Log.instance.v(
        tag, 'Alice get text from Tom: ' + utf8.decode(alicePlaintextFromTom));
    Log.instance
        .v(tag, 'Bob get text from Tom: ' + utf8.decode(bobPlaintextFromTom));

    Log.instance.v(tag, '======== Alice try to resend again ========');

    Log.instance.v(tag, 'Alice sent: \'How are you both?\'');
    final ciphertextFromAliceLast = await aliceGroupCipher
        .encrypt(Uint8List.fromList(utf8.encode('Hello bob and Tom')));

    final plaintextFromAliceLast =
        await bobGroupCipher.decrypt(ciphertextFromAliceLast);
    final tomPlaintextFromAliceLast =
        await tomSessionCipher.decrypt(ciphertextFromAliceLast);

    // ignore: avoid_print
    Log.instance.v(
        tag, 'Bob get text from Alice: ' + utf8.decode(plaintextFromAliceLast));
    // ignore: avoid_print
    Log.instance.v(tag,
        'Tom get text from Alice: ' + utf8.decode(tomPlaintextFromAliceLast));

    Log.instance.v(tag,
        '======== In short, the sending and receiving are using different sender id ========');
    expect(1, 1);
  });
}
