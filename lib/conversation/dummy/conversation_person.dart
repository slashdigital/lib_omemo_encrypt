import 'package:lib_omemo_encrypt/conversation/dummy/conversation_session.dart';

class ConversationPerson {
  final String personName;
  List<ConversationSession> appInstances = [];

  ConversationPerson(this.personName);

  static Future<ConversationPerson> init(
      String name, List<String> deviceIds) async {
    final conversation = ConversationPerson(name);
    final List<ConversationSession> chatUsers = [];
    for (var element in deviceIds) {
      chatUsers.add(await ConversationSession.createConversationSession(
          name: name, deviceId: element));
    }

    conversation.appInstances = chatUsers;
    return conversation;
  }
}
