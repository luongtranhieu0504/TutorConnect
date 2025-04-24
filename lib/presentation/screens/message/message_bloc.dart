
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../common/async_state.dart';
import '../../../common/stream_wrapper.dart';
import '../../../data/manager/account.dart';
import '../../../domain/repository/chat_repositpry.dart';
import '../../../domain/repository/message_repository.dart';
import 'message_state.dart';

@injectable
class MessageBloc extends Cubit<MessageState> {
  final ChatRepository _chatRepository;
  final MessageRepository _messageRepository;

  final openChatBroadcast = StreamWrapper<AsyncState<String>>(broadcast: true);


  MessageBloc(this._chatRepository, this._messageRepository)
      : super(MessageInitialState());

  void getConversations() async {
    emit(MessageLoadingState());
    try {
      final conversations = await _messageRepository.getConversations();
      emit(MessageSuccessState(chatUsers: conversations));
    } catch (e) {
      emit(MessageFailureState(error: e.toString()));
    }
  }

  Future<void> openOrCreateChat(String tutorId) async {
    openChatBroadcast.add(AsyncState.loading());

    final result = await _chatRepository.createOrGetConversation(
      userId1: Account.instance.user.uid,
      userId2: tutorId,
    );
    result.when(
      success: (conversationId) {
        openChatBroadcast.add(AsyncState.success(conversationId));
      },
      failure: (message) {
        openChatBroadcast.add(AsyncState.failure(message));
      },
    );
  }

}