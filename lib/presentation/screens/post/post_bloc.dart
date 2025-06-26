


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/common/async_state.dart';
import 'package:tutorconnect/domain/model/post.dart';
import 'package:tutorconnect/presentation/screens/post/post_state.dart';

import '../../../common/stream_wrapper.dart';
import '../../../domain/repository/post_repository.dart';

@injectable
class PostBloc extends Cubit<PostState> {

  final PostRepository _postRepository;

  final getPostsByIdBroadcast = StreamWrapper<AsyncState<Post>>(broadcast: true);
  final updatePostBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);

  final deletePostBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);
  final createPostBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);
  PostBloc(this._postRepository) : super(PostInitialState());

  void getPosts() async {
    emit(PostLoadingState());
    final posts = await _postRepository.getPosts();
    posts.when(
      success: (posts) {
        emit(PostSuccessState(posts: posts));
      },
      failure: (message) {
        emit(PostFailureState(error: message));
      },
    );
  }

  void createPost(Post post) async {
    createPostBroadcast.add(AsyncState.loading());
    final result = await _postRepository.createPost(post);
    result.when(
      success: (createdPost) {
        createPostBroadcast.add(AsyncState.success(true));
        getPosts();
      },
      failure: (message) {
        createPostBroadcast.add(AsyncState.failure(message));
      },
    );
  }

  void deletePost(int postId) async {
    deletePostBroadcast.add(AsyncState.loading());
    final result = await _postRepository.deletePost(postId);
    result.when(
      success: (isDeleted) {
        deletePostBroadcast.add(AsyncState.success(isDeleted));
        getPosts();
      },
      failure: (message) {
        deletePostBroadcast.add(AsyncState.failure(message));
      },
    );
  }

  void getPostsByTutorId(int id) async {
    getPostsByIdBroadcast.add(AsyncState.loading());
    final posts = await _postRepository.getPostById(id);
    posts.when(
      success: (posts) {
        getPostsByIdBroadcast.add(AsyncState.success(posts));
      },
      failure: (message) {
        getPostsByIdBroadcast.add(AsyncState.failure(message));
      },
    );
  }

  void updatePost(int postId,Post post) async {
    updatePostBroadcast.add(AsyncState.loading());
    final result = await _postRepository.updatePost(postId, post);
    result.when(
      success: (updatedPost) {
        updatePostBroadcast.add(AsyncState.success(true));
        getPosts();
      },
      failure: (message) {
        updatePostBroadcast.add(AsyncState.failure(message));
      },
    );
  }

  void likePost(int postId, int userId) async {
    final result = await _postRepository.likePost(postId, userId);
    result.when(
      success: (post) {
        getPosts();
      },
      failure: (message) {
        // Handle failure if needed
      },
    );
  }



}