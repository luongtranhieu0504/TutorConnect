
import 'package:tutorconnect/domain/model/message.dart';


abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  final int conversationId;

  ChatLoaded(this.messages, this.conversationId);
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}