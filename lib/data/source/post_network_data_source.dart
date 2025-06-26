

import 'package:injectable/injectable.dart';

import '../network/api/post_api.dart';
import '../network/dto/add_post_dto.dart';
import '../network/dto/post_dto.dart';
import '../network/dto/response_dto.dart';

@singleton
class PostNetworkDataSource {
  final PostApi _postApi;

  PostNetworkDataSource(this._postApi);

  Future<ResponseDto<List<PostDto>>> getPostsList() async {
    return _postApi.getPostsList();
  }

  Future<ResponseDto<PostDto>> addPost(AddPostDto postDto) => _postApi.addPost(postDto.toStrapiJson());

  Future<ResponseDto<PostDto>> updatePost(int id, Map<String, dynamic> data) =>
      _postApi.updatePost(id, {
        'data': data,
      });

  Future<ResponseDto<void>> deletePost(int id) async {
    return _postApi.deletePost(id);
  }

  Future<ResponseDto<PostDto>> getPostById(int id) async {
    return _postApi.getPostById(id);
  }

  Future<ResponseDto<PostDto>> likePost(int id, int userId) async {
    return _postApi.likePost(id, {'userId': userId});
  }
}