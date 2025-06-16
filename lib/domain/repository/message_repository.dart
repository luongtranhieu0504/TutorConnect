import '../../common/task_result.dart';
import '../model/message.dart';

abstract class MessageRepository {
  // Get messages for a conversation
  Future<TaskResult<List<Message>>> getMessages(int conversationId);

  // Send a new message
  Future<TaskResult<Message>> sendMessage(Message message) ;

  // Get a stream of messages for real-time updates
  Stream<Message> getMessageStream();

  // Mark message as read
  Future<TaskResult<Message>> markAsRead(int messageId);

  // Delete a message
  Future<void> deleteMessage(int messageId);

  // Join a conversation to receive messages
  void joinConversation(int conversationId);

  // Leave a conversation to stop receiving messages
  void leaveConversation(int conversationId);

  void sendMessageViaSocket(int conversationId, Message message);

  bool get isSocketConnected;

  Stream<bool> get socketConnectionStream;

}