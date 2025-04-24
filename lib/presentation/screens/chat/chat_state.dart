
import '../../../data/models/chat.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<ChatModel> chats;
  final String conversationId;

  ChatSuccess(this.chats, this.conversationId);
}

class ChatFailure extends ChatState {
  final String message;

  ChatFailure(this.message);
}