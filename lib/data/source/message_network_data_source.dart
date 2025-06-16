import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/network/api/message_api.dart';
import 'package:tutorconnect/data/network/dto/message_dto.dart';
import 'package:tutorconnect/data/network/dto/response_dto.dart';
import 'package:tutorconnect/data/network/dto/send_message_dto.dart';

@singleton
class MessageNetworkDataSource {
  final MessageApi _messageApi;

  MessageNetworkDataSource(this._messageApi);

  Future<ResponseDto<List<MessageDto>>> getMessages(int conversationId) async {
    return _messageApi.getMessages(conversationId);
  }

  Future<ResponseDto<MessageDto>> sendMessage(SendMessageDto messageDto) =>
      _messageApi.sendMessage(messageDto.toStrapiJson());

  Future<ResponseDto<MessageDto>> markAsRead(int messageId, Map<String, dynamic> data) async {
    return _messageApi.markAsRead(messageId, data);
  }

  Future<ResponseDto<void>> deleteMessage(int messageId) async {
    return _messageApi.deleteMessage(messageId);
  }
}