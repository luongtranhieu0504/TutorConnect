
import 'package:tutorconnect/common/task_result.dart';

import '../model/post.dart';

abstract class PostRepository {
  Future<TaskResult<List<Post>>> getPosts();


  Future<TaskResult<Post>> getPostById(int postId);

  Future<TaskResult<Post>> createPost(Post post);

  Future<TaskResult<Post>> updatePost(int int, Post post);

  Future<TaskResult<bool>> deletePost(int id);

  Future<TaskResult<Post>> likePost(int postId, int userId);
}