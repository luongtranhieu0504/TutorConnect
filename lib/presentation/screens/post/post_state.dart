

import '../../../domain/model/post.dart';

abstract class PostState {}

class PostInitialState extends PostState {}

class PostLoadingState extends PostState {}

class PostSuccessState extends PostState {
  final List<Post> posts;

  PostSuccessState({
    required this.posts,
  });
}

class PostFailureState extends PostState {
  final String error;

  PostFailureState({
    required this.error,
  });
}