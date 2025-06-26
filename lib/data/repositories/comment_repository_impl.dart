

import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/mapper/comment_mapper.dart';
import 'package:tutorconnect/data/network/dto/add_comment_dto.dart';

import '../../common/task_result.dart';
import '../../domain/model/comment.dart';
import '../../domain/repository/comment_repository.dart';
import '../network/api_call.dart';
import '../source/comment_network_data_source.dart';

@Singleton(as: CommentRepository)
class CommentRepositoryImpl implements CommentRepository {

  final CommentNetworkDataSource _dataSource;

  CommentRepositoryImpl(this._dataSource);


  @override
  Future<TaskResult<List<Comment>>> getCommentsList(int postId) => callApi(() async {
    final response = await _dataSource.getCommentsList(postId);
    return response.data!.map((dto) => dto.toModel()).toList();
  });

  @override
  Future<TaskResult<Comment>> addComment(Comment comment) => callApi(() async {
    final addCommentDto = AddCommentDto(
      content: comment.content,
      imageUrls: comment.imageUrls,
      author: comment.author?.id,
      post: comment.post?.id,
    );
    final response = await _dataSource.addComment(addCommentDto);
    return response.data!.toModel();
  });

  @override
  Future<TaskResult<bool>> deleteComment(int id) => callApi(() async {
    await _dataSource.deleteComment(id);
    return true;
  });
}