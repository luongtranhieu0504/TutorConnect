
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tutorconnect/data/network/dto/conversation_dto.dart';

part 'conversation_api.g.dart';

@RestApi()
abstract class ConversationApi {
  factory ConversationApi(Dio dio) = _ConversationApi;

  // Get list of conversations
  @POST("/api/conversations/find-or-create")
  Future<Response<ConversationDto>> findOrCreateConversation(
    @Body() Map<String, dynamic> body
  );
}