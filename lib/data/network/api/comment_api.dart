

import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tutorconnect/data/network/dto/comment_dto.dart';
import 'package:tutorconnect/data/network/dto/response_dto.dart';

part 'comment_api.g.dart';

@RestApi()
abstract class CommentApi {
  factory CommentApi(Dio dio) = _CommentApi;

  // Get list of comments for a post
  @GET('/api/comments')
  Future<ResponseDto<List<CommentDto>>> getComments(
      @Query('filters[post][id][\$eq]') int postId,
      @Query('populate') String populateAuthor, // truyền 'author'
      );

  // post a new comment
  @POST('/api/comments')
  Future<ResponseDto<CommentDto>> addComment(
    @Body() Map<String, dynamic> commentDto,
  );

  // Delete a comment
  @DELETE('/api/comments/{id}')
  Future<ResponseDto<void>> deleteComment(
    @Path('id') int id,
  );

}