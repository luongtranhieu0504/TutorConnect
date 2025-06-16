import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/domain/repository/conversation_repository.dart';

import '../../../common/async_state.dart';
import '../../../common/stream_wrapper.dart';
import '../../../data/manager/account.dart';
import '../../../domain/model/message.dart';
import '../../../domain/repository/message_repository.dart';
import '../../../domain/services/notification_service.dart';
import 'chat_state.dart';

@injectable
class ChatBloc extends Cubit<ChatState> {
  final MessageRepository _messageRepository;
  final ConversationRepository _conversationRepository;
  final messageStreamWrapper = StreamWrapper<Message>();
  final sendMessageBroadcast = StreamWrapper<AsyncState<Message>>(broadcast: true);
  final markAsReadBroadcast = StreamWrapper<AsyncState<Message>>(broadcast: true);
  final deleteBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);
  final NotificationService _notificationService = NotificationService();

  StreamSubscription? _messageSubscription;
  Message? _latestMessage;
  int? _currentConversationId;

  ChatBloc(this._messageRepository, this._conversationRepository) : super(ChatInitial());

  void init(int conversationId) {
    emit(ChatLoading());
    _currentConversationId = conversationId;
    // Set current conversation ID in notification service
    _notificationService.setCurrentConversationId(conversationId);

    // Join conversation via socket
    _messageRepository.joinConversation(conversationId);

    // Listen to incoming messages
    _messageSubscription = _messageRepository.getMessageStream().listen((message) {
      if (message.conversation?.id == conversationId) {
        _latestMessage = message;
        messageStreamWrapper.add(message);
        _updateState();
      }
    });

    // Load existing messages
    loadMessages(conversationId);
  }

  Future<void> loadMessages(int conversationId) async {
    // ✨ Chỉ emit ChatLoading nếu chưa có dữ liệu
    if (state is! ChatLoaded) emit(ChatLoading());

    final result = await _messageRepository.getMessages(conversationId);

    result.when(
      success: (messages) => emit(ChatLoaded(messages, conversationId)),
      failure: (message) => emit(ChatError(message)),
    );
  }

  // Modify the sendMessage method in ChatBloc
  Future<void> sendMessage(Message message) async {
    sendMessageBroadcast.add(AsyncState.loading());
    // Immediately add message to state for local UI update
    if (state is ChatLoaded && _currentConversationId != null) {
      final currentState = state as ChatLoaded;
      final updatedMessages = [...currentState.messages, message];
      emit(ChatLoaded(updatedMessages, _currentConversationId!));
    }
    // Also send via socket for real-time delivery
    _messageRepository.sendMessageViaSocket(_currentConversationId!, message);
    // Still save to database via API
    final result = await _messageRepository.sendMessage(message);
    result.when(
      success: (sentMessage) async {
        sendMessageBroadcast.add(AsyncState.success(sentMessage));
        if (message.content != null && message.content!.isNotEmpty && _currentConversationId != null) {
          await _conversationRepository.updateLastMessage(
              _currentConversationId!,
              message.content!
          );
        }
      },
      failure: (error) {
        sendMessageBroadcast.add(AsyncState.failure(error));
      },
    );
  }

  Future<void> markAsRead(int messageId) async {
    markAsReadBroadcast.add(AsyncState.loading());

    final result = await _messageRepository.markAsRead(messageId);

    result.when(
      success: (message) {
        markAsReadBroadcast.add(AsyncState.success(message));
        _updateState();
      },
      failure: (error) {
        markAsReadBroadcast.add(AsyncState.failure(error));
      },
    );
  }

  Future<void> deleteMessage(int messageId) async {
    deleteBroadcast.add(AsyncState.loading());

    await _messageRepository.deleteMessage(messageId);
    deleteBroadcast.add(AsyncState.success(true));

    // Refresh messages after deletion
    if (_currentConversationId != null) {
      loadMessages(_currentConversationId!);
    }
  }

  void _updateState() {
    if (state is ChatLoaded && _currentConversationId != null) {
      final currentMessages = (state as ChatLoaded).messages;
      final newMessage = _latestMessage;  // Use the stored message

      if (newMessage != null) {
        // Rest of your code remains the same
        final messageExists = currentMessages.any((m) => m.id == newMessage.id);

        if (!messageExists) {
          final updatedMessages = [...currentMessages, newMessage];
          emit(ChatLoaded(updatedMessages, _currentConversationId!));
        }
      }
    }
  }

  /// Joins a conversation by its ID.
  void joinConversation(int conversationId) {
    if (_currentConversationId != null && _currentConversationId != conversationId) {
      leaveConversation();
    }
    init(conversationId);
  }
  void leaveConversation() {
    if (_currentConversationId != null) {
      _messageRepository.leaveConversation(_currentConversationId!);
      _notificationService.setCurrentConversationId(null);
      _currentConversationId = null;
      _messageSubscription?.cancel();
      emit(ChatInitial());
    }
  }

  bool get isSocketConnected => _messageRepository.isSocketConnected;

  Stream<bool> get socketConnectionStream => _messageRepository.socketConnectionStream;

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    if (_currentConversationId != null) {
      _messageRepository.leaveConversation(_currentConversationId!);
      _notificationService.setCurrentConversationId(null);
    }


    messageStreamWrapper.close();
    sendMessageBroadcast.close();
    markAsReadBroadcast.close();
    deleteBroadcast.close();

    return super.close();
  }
}