
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tutorconnect/data/network/dto/conversation_dto.dart';
import 'package:tutorconnect/data/network/dto/response_dto.dart';

part 'conversation_api.g.dart';

@RestApi()
abstract class ConversationApi {
  factory ConversationApi(Dio dio) = _ConversationApi;

  // Get list of conversations
  @POST("/api/conversations/find-or-create")
  Future<ResponseDto<ConversationDto>> findOrCreateConversation(
    @Body() Map<String, dynamic> data
  );

  @GET('/api/my-conversations')
  Future<ResponseDto<List<ConversationDto>>> getConversations({
    @Query('studentId') int? studentId,
    @Query('tutorId') int? tutorId,
  });

  @PUT('/api/conversations/{id}')
  Future<ResponseDto<ConversationDto>> updateLastMessage(
    @Path('id') int conversationId,
    @Body() Map<String, dynamic> data,
  );
}