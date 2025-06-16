import '../../../domain/model/conversation.dart';

abstract class MessageState {}
class MessageInitialState extends MessageState {}

class MessageLoadingState extends MessageState {}

class MessageSuccessState extends MessageState {
  final List<Conversation> conversations;
  MessageSuccessState({
    required this.conversations,
  });

}
class MessageFailureState extends MessageState {
  final String error;

  MessageFailureState({
    required this.error,
  });
}

