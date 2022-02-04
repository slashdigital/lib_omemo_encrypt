import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/session_cipher.dart';
import 'package:lib_omemo_encrypt/keys/bundle/receiving_prekey_bundle.dart';
import 'package:lib_omemo_encrypt/keys/whisper/signed_prekey.dart';

import 'package:lib_omemo_encrypt/lib_omemo_encrypt.dart';
import 'package:lib_omemo_encrypt/storage/in-memory/memory_storage.dart';
import 'package:lib_omemo_encrypt/utils/log.dart';

const _COUNT_PREKEYS = 20;

void main() {
  late Log log;
  late Axololt encryption;
  const tag = 'Axololt';
  setUp(() {
    log = Log.instance;
    encryption = Axololt();
  });
  test('should generate prekeys and verify one prekey bundle', () async {
    /// You get
    /// - prekey
    /// - signedprekey
    /// - signature (sign signedprekey public key) by identity key
    /// - identity key
    final alicekeyPackage =
        await encryption.generatePreKeysPackage(_COUNT_PREKEYS);
    // ### 1. Alice start application and init store and keys
    final sameKeyIndex = 1;

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
    final bobKeyPackage =
        await encryption.generatePreKeysPackage(_COUNT_PREKEYS);
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
    Log.instance.d(tag,
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
        registrationId: bobKeyPackage.registrationId,
        preKey: bobReceivingPreKeyPublic,
        signedPreKey: await bobReceivingSignKey.signedPreKey,
        signature: signature);

    // ### 3.4 ? bob store alice prekey in his local storage
    final bobStore = MemoryStorage(
      localRegistrationId: bobKeyPackage.registrationId,
      localIdentityKeyPair: bobKeyPackage.identityKeyPair,
    );

    // ### 4 Bob try to init the first cipher session

    final bobSessionFactory = SessionFactory(store: bobStore);
    final bobSession = await bobSessionFactory
        .createSessionFromPreKeyBundle(bobReceivingBundle);
    // ### 5. bob try to encrypt and the first whisper key
    const bobMessageToAlice = 'I want to chat hello';
    final bobCipherSession = SessionCipher();
    final encryptedMessage = await bobCipherSession.encryptMessage(
        bobSession, Utils.convertStringToBytes(bobMessageToAlice));

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

    log.d(tag, bobSession);
    log.d(tag, encryptedMessage);

    // 7. Alice receive the key and message thru server xmpp?
    // Is it key exchange?
    // if (encryptedMessage.isPreKeyWhisperMessage) {
    //   // Decrypt key exchange and
    // } else {
    //   // Decrypt text
    // }
    // 7.1 Alice try to get pre key with bob that send to pop
    // final aliceReceivingPreKeyId = bobKeyPackage.preKeys[0].id;
    // final aliceReceivingPreKeyPublic =
    //     await bobKeyPackage.preKeys[0].keyPair!.extractPublicKey();
    // final aliceReceivingSignKey = bobKeyPackage.signedPreKeyPair;
    // final aliceReceivingIdentityKey = bobKeyPackage.identityKeyPair;
    // final aliceReceivingSignKeyId = bobKeyPackage.signedPreKeyPairId;

    // final aliceReceivingPreKeyId = alicekeyPackage.preKeys[sameKeyIndex].id;
    // final aliceReceivingPreKeyPublic =
    //     await alicekeyPackage.preKeys[sameKeyIndex].keyPair!.extractPublicKey();
    // final aliceReceivingSignKey = alicekeyPackage.signedPreKeyPair;
    // final aliceReceivingIdentityPublicKey =
    //     await bobKeyPackage.identityKeyPair.extractPublicKey();
    // final aliceReceivingSignKeyId = alicekeyPackage.signedPreKeyPairId;
    // final aliceReceivingRegId = bobKeyPackage.registrationId;
    // final aliceReceivingSignature = bobKeyPackage.signature;

    // final sign = await encryption.generateSignature(aliceReceivingIdentityKey, aliceReceivingSignKey);
    // ### 7.2 Alice construct the receiving prekey bundle

    // Alice set key for Bob # use key 0
    // const aliceBobUserId = 'bob@example.co';
    // final aliceReceivingBundle = ReceivingPreKeyBundle(
    //     userId: aliceBobUserId,
    //     identityKey: aliceReceivingIdentityPublicKey,
    //     registrationId: aliceReceivingRegId,
    //     preKey: aliceReceivingPreKeyPublic,
    //     signedPreKey: await aliceReceivingSignKey.extractPublicKey(),
    //     preKeyId: aliceReceivingPreKeyId,
    //     signedPreKeyId: aliceReceivingSignKeyId,
    //     signature: aliceReceivingSignature);
    // ### 7.2 Alice construct the receiving prekey bundle

    // ### 8 Alice try to init the first cipher session
    Log.instance.d(tag,
        '============================= ALICE start getting the prekey thru whisper message');
    aliceStore.addLocalSignedPreKeyPair(SignedPreKeyPair(
      signedPreKeyId: alicekeyPackage.signedPreKeyPairId,
      key: alicekeyPackage.signedPreKeyPair,
    ));

    final aliceSessionFactory = SessionFactory(store: aliceStore);
    Session
        _aliceSession = /*await aliceSessionFactory
        .createSessionFromPreKeyBundle(aliceReceivingBundle); / */
        Session();

    final aliceSession =
        await aliceSessionFactory.createSessionFromPreKeyWhisperMessage(
            _aliceSession, encryptedMessage.body);
    _aliceSession = aliceSession.session;
    // // ### 9. Alice has the session now try to decrypt message
    final aliceCipherSession = SessionCipher();
    final decryptedMessage = await aliceCipherSession
        .decryptPreKeyWhisperMessage(_aliceSession, encryptedMessage.body);
    print(decryptedMessage);
    log.d(tag, decryptedMessage);

    // convo
    // final aliceEncMsgA = await aliceCipherSession.encryptMessage(
    //     _aliceSession, Utils.convertStringToBytes('Hello Bob'));

    // /// Bob decrypt it?
    // ///
    // final plaintext = aliceEncMsgA.isPreKeyWhisperMessage
    //     ? await bobCipherSession.decryptPreKeyWhisperMessage(
    //         bobSession, aliceEncMsgA.body)
    //     : await bobCipherSession.decryptWhisperMessage(
    //         bobSession, aliceEncMsgA.body);
    expect(bobMessageToAlice, utf8.decode(decryptedMessage.plainText));
  });
}
