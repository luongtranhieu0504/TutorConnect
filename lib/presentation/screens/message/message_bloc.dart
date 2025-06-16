
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/domain/model/conversation.dart';
import 'package:tutorconnect/domain/repository/conversation_repository.dart';

import '../../../common/async_state.dart';
import '../../../common/stream_wrapper.dart';
import '../../../data/manager/account.dart';
import '../../../domain/repository/message_repository.dart';
import 'message_state.dart';

@injectable
class MessageBloc extends Cubit<MessageState> {
  final MessageRepository _messageRepository;

  final ConversationRepository _conversationRepository;

  final openChatBroadcast = StreamWrapper<AsyncState<String>>(broadcast: true);


  MessageBloc(this._conversationRepository, this._messageRepository)
      : super(MessageInitialState());

  void getConversations({int? studentId, int? tutorId}) async {
    emit(MessageLoadingState());
    final conversations = await _conversationRepository.getConversations(studentId: studentId, tutorId: tutorId);
    conversations.when(
      success: (conversations) {
        emit(MessageSuccessState(conversations: conversations));
      },
      failure: (message) {
        emit(MessageFailureState(error: message));
      },
    );
  }

  // Future<void> openOrCreateChat(String tutorId) async {
  //   openChatBroadcast.add(AsyncState.loading());
  //
  //   final result = await _chatRepository.createOrGetConversation(
  //     userId1: Account.instance.user.uid,
  //     userId2: tutorId,
  //   );
  //   result.when(
  //     success: (conversationId) {
  //       openChatBroadcast.add(AsyncState.success(conversationId));
  //     },
  //     failure: (message) {
  //       openChatBroadcast.add(AsyncState.failure(message));
  //     },
  //   );
  // }

}