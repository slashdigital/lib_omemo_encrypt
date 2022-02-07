import 'package:lib_omemo_encrypt/messages/whisper_sender_distribution_message.dart';
import 'package:lib_omemo_encrypt/sessions/session_group.dart';

abstract class GroupSessionFactoryInterface {
  Future<WhisperSenderDistributionMessage> create(SessionGroup senderGroup);
  storeKeyDistribution(SessionGroup senderGroup,
      WhisperSenderDistributionMessage senderKeyDistributionMessageWrapper);
}
