

import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/mapper/post_mapper.dart';

import '../../common/task_result.dart';
import '../../domain/model/post.dart';
import '../../domain/repository/post_repository.dart';
import '../network/api_call.dart';
import '../network/dto/add_post_dto.dart';
import '../source/post_network_data_source.dart';

@Singleton(as: PostRepository)
class PostRepositoryImpl implements PostRepository {
  final PostNetworkDataSource _dataSource;

  PostRepositoryImpl(this._dataSource);

  @override
  Future<TaskResult<List<Post>>> getPosts() => callApi(() async {
    final response = await _dataSource.getPostsList();
    return response.data?.map((dto) => dto.toModel()).toList() ?? [];
  });

  @override
  Future<TaskResult<Post>> createPost(Post post) => callApi(() async {
    final postDto = AddPostDto(
      content: post.content,
      imageUrls: post.imageUrls,
      author: post.author?.id,
      likedBy: post.likedBy?.map((user) => user.id).toList(),
      likeCount: post.likeCount,
      commentCount: post.commentCount,
    );

    final response = await _dataSource.addPost(postDto);
    return response.data!.toModel();
  });

  @override
  Future<TaskResult<Post>> updatePost(int id, Post post) => callApi(() async {
    final updatePost = {
      'content': post.content,
      'image_urls': post.imageUrls,
      'author': post.author?.id,
      'liked_by': post.likedBy?.map((id) => id).toList(),
      'like_count': post.likeCount,
      'comment_count': post.commentCount,
    };

    final response = await _dataSource.updatePost(id, updatePost);
    return response.data!.toModel();
  });

  @override
  Future<TaskResult<bool>> deletePost(int id) => callApi(() async {
    await _dataSource.deletePost(id);
    return true;
  });

  @override
  Future<TaskResult<Post>> getPostById(int postId) {
    return callApi(() async {
      final response = await _dataSource.getPostById(postId);
      return response.data!.toModel();
    });
  }

  @override
  Future<TaskResult<Post>> likePost(int postId, int userId) {
    return callApi(() async {
      final response = await _dataSource.likePost(postId, userId);
      return response.data!.toModel();
    });
  }
}