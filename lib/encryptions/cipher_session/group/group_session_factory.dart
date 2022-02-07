import 'package:lib_omemo_encrypt/encryptions/axolotl/axolotl.dart';
import 'package:lib_omemo_encrypt/encryptions/cipher_session/group/group_session_factory_interface.dart';
import 'package:lib_omemo_encrypt/messages/whisper_sender_distribution_message.dart';
import 'package:lib_omemo_encrypt/sessions/session_group.dart';
import 'package:lib_omemo_encrypt/storage/in-memory/group_memory_storage.dart';
import 'package:lib_omemo_encrypt/utils/utils.dart';

class GroupSessionFactory extends GroupSessionFactoryInterface {
  final GroupMemoryStorage groupSessionStore;
  final Axololt axololt = Axololt();

  GroupSessionFactory(this.groupSessionStore);

  @override
  storeKeyDistribution(
      SessionGroup senderGroup,
      WhisperSenderDistributionMessage
          senderKeyDistributionMessageWrapper) async {
    final senderKeyRecord =
        await groupSessionStore.loadSessionGroupKey(senderGroup);
    await senderKeyRecord.addSenderKeyState(
        senderKeyDistributionMessageWrapper.id,
        senderKeyDistributionMessageWrapper.iteration,
        senderKeyDistributionMessageWrapper.chainKey,
        senderKeyDistributionMessageWrapper.signatureKey);
    await groupSessionStore.storeSessionGroupKey(senderGroup, senderKeyRecord);
  }

  @override
  Future<WhisperSenderDistributionMessage> create(
      SessionGroup senderGroup) async {
    final senderKeyRecord =
        await groupSessionStore.loadSessionGroupKey(senderGroup);
    if (senderKeyRecord.isEmpty) {
      await senderKeyRecord.setSenderKeyState(Utils.createRandomSequence(), 0,
          Utils.generateRandomBytes(), await axololt.generateKeyPair());
      await groupSessionStore.storeSessionGroupKey(
          senderGroup, senderKeyRecord);
    }
    final state = senderKeyRecord.getSenderKeyState();
    final whisperDistributionMessage = WhisperSenderDistributionMessage.create(
        state.keyId,
        state.senderChainKey.iteration,
        state.senderChainKey.seed,
        state.signingKeyPublic);
    return whisperDistributionMessage;
  }
}
