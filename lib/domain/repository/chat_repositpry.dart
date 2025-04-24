import '../../common/task_result.dart';
import '../../data/models/chat.dart';

abstract interface class ChatRepository {
  Stream<TaskResult<List<ChatModel>>> listenChat(String conversationId);
  Future<TaskResult<String>> createOrGetConversation({
    required String userId1,
    required String userId2,
  });
  Future<TaskResult<void>> sendChat(String conversationId, ChatModel chat);
  Future<TaskResult<void>> deleteConversation(String conversationId);

}