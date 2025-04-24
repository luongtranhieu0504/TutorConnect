import 'package:tutorconnect/data/models/coversation.dart';

abstract class MessageState {}
class MessageInitialState extends MessageState {}

class MessageLoadingState extends MessageState {}

class MessageSuccessState extends MessageState {
  final List<ConversationWithUser> chatUsers;

  MessageSuccessState({
    required this.chatUsers,
  });

}
class MessageFailureState extends MessageState {
  final String error;

  MessageFailureState({
    required this.error,
  });
}

