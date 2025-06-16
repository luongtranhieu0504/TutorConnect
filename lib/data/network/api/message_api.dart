import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tutorconnect/data/network/dto/message_dto.dart';
import 'package:tutorconnect/data/network/dto/response_dto.dart';

part 'message_api.g.dart';

@RestApi()
abstract class MessageApi {
  factory MessageApi(Dio dio) = _MessageApi;

  // Get messages for a conversation
  @GET('/api/messages/flat')
  Future<ResponseDto<List<MessageDto>>> getMessages(
    @Query('conversationId') int conversationId,
  );

  // Send a new message
  @POST('/api/messages')
  Future<ResponseDto<MessageDto>> sendMessage(
      @Body() Map<String, dynamic> body,
      );

  // Mark message as read
  @PUT('/api/messages/{id}')
  Future<ResponseDto<MessageDto>> markAsRead(
    @Path('id') int messageId,
    @Body() Map<String, dynamic> data,
  );

  // Delete a message
  @DELETE('/api/messages/{id}')
  Future<ResponseDto<void>> deleteMessage(
    @Path('id') int messageId,
  );
}