

import 'package:tutorconnect/common/task_result.dart';

import '../model/comment.dart';

abstract class CommentRepository {
  Future<TaskResult<List<Comment>>> getCommentsList(int postId);

  // Add a new comment to a post
  Future<TaskResult<Comment>> addComment(Comment comment);

  // Delete a comment
  Future<TaskResult<bool>> deleteComment(int id);
}