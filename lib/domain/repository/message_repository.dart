import '../../data/models/coversation.dart';

abstract interface class MessageRepository {
  Future<List<ConversationWithUser>> getConversations();
  Future<void> deleteMessage(String conversationId);
  Future<void> updateMessage(String messageId, String newContent);
}