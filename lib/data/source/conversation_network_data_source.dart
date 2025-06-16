


import 'package:injectable/injectable.dart';

import '../network/api/conversation_api.dart';
import '../network/dto/conversation_dto.dart';
import '../network/dto/response_dto.dart';

@singleton
class ConversationNetworkDataSource {
  final ConversationApi _conversationApi;

  ConversationNetworkDataSource(this._conversationApi);

  Future<ResponseDto<ConversationDto>> findOrCreateConversation(int studentId, int tutorId) =>
    _conversationApi.findOrCreateConversation(
        {
          "studentId": studentId,
          "tutorId": tutorId,
        }
    );

  Future<ResponseDto<List<ConversationDto>>> getConversations({
    int? studentId,
    int? tutorId,
  }) =>
    _conversationApi.getConversations(
      studentId: studentId,
      tutorId: tutorId,
    );

  Future<ResponseDto<ConversationDto>> updateLastMessage(int conversationId, String message) async {
    return _conversationApi.updateLastMessage(conversationId, {
      'data': {
        'lastMessage': message,
        'lastTimestamp': DateTime.now().toIso8601String()
      }
    });
  }
}