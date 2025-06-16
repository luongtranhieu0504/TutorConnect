
import 'package:tutorconnect/domain/model/conversation.dart';
import '../../common/task_result.dart';

abstract class ConversationRepository {
  Future<TaskResult<Conversation>> findOrCreateConversation(int studentId, int tutorId);

  Future<TaskResult<List<Conversation>>> getConversations({
    int? studentId,
    int? tutorId,
  });

  Future<TaskResult<Conversation>> updateLastMessage(int conversationId, String message);

}