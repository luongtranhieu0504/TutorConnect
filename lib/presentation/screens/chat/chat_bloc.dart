
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/common/stream_wrapper.dart';
import '../../../common/async_state.dart';
import '../../../data/models/chat.dart';
import '../../../domain/repository/chat_repositpry.dart';
import 'chat_state.dart';

@injectable
class ChatBloc extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  final sendChatBroadcast = StreamWrapper<AsyncState<void>>(broadcast: true);
  StreamSubscription? _chatSubscription;

  ChatBloc(this._chatRepository) : super(ChatInitial());

  void listenChat(String conversationId) async {
    emit(ChatLoading());

    _chatSubscription?.cancel();
    _chatRepository.listenChat(conversationId).listen(
      (result) {
        result.when(
          success: (chat) => emit(ChatSuccess(chat, conversationId)),
          failure: (error) => emit(ChatFailure(error)),
        );
      }
    );

  }

  void createOrGetConversation(String userId1, String userId2) async {
    emit(ChatLoading());
    final result = await _chatRepository.createOrGetConversation(userId1: userId1, userId2: userId2);
    result.when(
      success: (conversationId) => listenChat(conversationId),
      failure: (error) => emit(ChatFailure(error)),
    );
  }

  void sendChat(String conversationId, ChatModel chat) async {
    sendChatBroadcast.add(AsyncState.loading());
    final result = await _chatRepository.sendChat(conversationId, chat);
    result.when(
      success: (_) => sendChatBroadcast.add(AsyncState.success(null)),
      failure: (error) => sendChatBroadcast.add(AsyncState.failure(error)),
    );
  }

  void deleteConversation(String conversationId) async {
    emit(ChatLoading());
    final result = await _chatRepository.deleteConversation(conversationId);
    result.when(
      success: (_) => emit(ChatInitial()),
      failure: (error) => emit(ChatFailure(error)),
    );
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }

}
