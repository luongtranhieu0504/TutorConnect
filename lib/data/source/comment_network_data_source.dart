

import 'package:injectable/injectable.dart';

import '../network/api/comment_api.dart';
import '../network/dto/add_comment_dto.dart';
import '../network/dto/comment_dto.dart';
import '../network/dto/response_dto.dart';

@singleton
class CommentNetworkDataSource {
  final CommentApi _commentApi;

  CommentNetworkDataSource(this._commentApi);

  Future<ResponseDto<List<CommentDto>>> getCommentsList(int postId) async {
    return _commentApi.getComments(postId, 'author');
  }

  Future<ResponseDto<CommentDto>> addComment(AddCommentDto commentDto) => _commentApi.addComment(commentDto.toStrapiJson());

  Future<ResponseDto<void>> deleteComment(int id) async {
    return _commentApi.deleteComment(id);
  }

}