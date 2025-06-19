

import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../dto/post_dto.dart';
import '../dto/response_dto.dart';

part 'post_api.g.dart';

@RestApi()
abstract class PostApi {
  factory PostApi(Dio dio) = _PostApi;

  // Get list of posts
  @GET('/api/posts')
  Future<ResponseDto<List<PostDto>>> getPostsList();

  // Get a single post by ID
  @GET('/api/posts/{id}')
  Future<ResponseDto<PostDto>> getPostById(
    @Path('id') int id,
  );

  // Add a new post
  @POST('/api/posts')
  Future<ResponseDto<PostDto>> addPost(
    @Body() Map<String, dynamic> postDto,
  );

  // Update an existing post
  @PUT('/api/posts/{id}')
  Future<ResponseDto<PostDto>> updatePost(
    @Path('id') int id,
    @Body() Map<String, dynamic> data,
  );

  // Delete a post
  @DELETE('/api/posts/{id}')
  Future<ResponseDto<void>> deletePost(
    @Path('id') int id,
  );
}