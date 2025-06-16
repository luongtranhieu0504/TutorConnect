import 'package:injectable/injectable.dart';
import 'package:tutorconnect/common/task_result.dart';
import 'package:tutorconnect/data/mapper/message_mapper.dart';
import 'package:tutorconnect/data/network/api_call.dart';
import 'package:tutorconnect/data/network/dto/message_dto.dart';
import 'package:tutorconnect/data/network/dto/send_message_dto.dart';
import 'package:tutorconnect/data/network/socket/socket_service.dart';
import 'package:tutorconnect/data/source/message_network_data_source.dart';
import 'package:tutorconnect/domain/model/message.dart';
import 'package:tutorconnect/domain/repository/message_repository.dart';

@Singleton(as: MessageRepository)
class MessageRepositoryImpl implements MessageRepository {
  final MessageNetworkDataSource _dataSource;
  final SocketService _socketService;

  MessageRepositoryImpl(this._dataSource, this._socketService);

  @override
  Future<TaskResult<Message>> sendMessage(Message message) {
    return callApi(() async {
      final messageDto = SendMessageDto(
        sender: message.sender!.id,
        receiver: message.receiver!.id,
        conversation: message.conversation!.id,
        content: message.content!,
        type: message.type!,
        timestamp: DateTime.now(),
        isRead: false,
        imageUrl: message.imageUrl,
        videoUrl: message.videoUrl,
        fileUrl: message.fileUrl,
      );
      final response = await _dataSource.sendMessage(messageDto);
      return response.data!.toModel();
    });
  }

  @override
  void sendMessageViaSocket(int conversationId, Message message) {
    _socketService.sendMessage(conversationId, message);
  }

  @override
  Future<TaskResult<List<Message>>> getMessages(int conversationId) {
    return callApi(() async {
      final response = await _dataSource.getMessages(conversationId);
      return response.data!.map((dto) => dto.toModel()).toList();
    });
  }

  @override
  Future<TaskResult<Message>> markAsRead(int messageId) {
    return callApi(() async {
      final response = await _dataSource.markAsRead(messageId, {
        'data': {'isRead': true}
      });
      return response.data!.toModel();
    });
  }

  @override
  Future<TaskResult<bool>> deleteMessage(int messageId) {
    return callApi(() async {
      await _dataSource.deleteMessage(messageId);
      return true;
    });
  }

  @override
  Stream<Message> getMessageStream() {
    return _socketService.messageStream;
  }

  @override
  void joinConversation(int conversationId) {
    _socketService.joinConversation(conversationId);
  }

  @override
  void leaveConversation(int conversationId) {
    _socketService.leaveConversation(conversationId);
  }

  @override
  bool get isSocketConnected => _socketService.isConnected;

  @override
  Stream<bool> get socketConnectionStream => _socketService.connectedStream;

}