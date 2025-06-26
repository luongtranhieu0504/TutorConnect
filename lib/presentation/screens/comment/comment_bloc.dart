

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../common/async_state.dart';
import '../../../common/stream_wrapper.dart';
import '../../../domain/model/comment.dart';
import '../../../domain/repository/comment_repository.dart';
import 'comment_state.dart';

@injectable
class CommentBloc extends Cubit<CommentState> {
  final CommentRepository _commentRepository;
  final commentStreamWrapper = StreamWrapper<Comment>();
  final addCommentBroadcast = StreamWrapper<AsyncState<Comment>>(broadcast: true);
  final deleteCommentBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);

  CommentBloc(this._commentRepository) : super(CommentInitial());

  void init(int postId) {
    emit(CommentLoading());
    loadComments(postId);
  }

  Future<void> loadComments(int postId) async {
    final result = await _commentRepository.getCommentsList(postId);
    result.when(
      success: (comments) => emit(CommentLoaded(comments)),
      failure: (message) => emit(CommentError(message)),
    );
  }

  Future<void> addComment(Comment comment) async {
    addCommentBroadcast.add(AsyncState.loading());
    final result = await _commentRepository.addComment(comment);
    result.when(
      success: (newComment) {
        if (state is CommentLoaded) {
          final currentState = state as CommentLoaded;
          final updatedComments = [...currentState.comments, newComment];
          emit(CommentLoaded(updatedComments));
        }
        addCommentBroadcast.add(AsyncState.success(newComment));
      },
      failure: (message) => addCommentBroadcast.add(AsyncState.failure(message)),
    );
  }

  Future<void> deleteComment(int commentId) async {
    deleteCommentBroadcast.add(AsyncState.loading());
    final result = await _commentRepository.deleteComment(commentId);
    result.when(
      success: (_) {
        if (state is CommentLoaded) {
          final currentState = state as CommentLoaded;
          final updatedComments = currentState.comments.where((c) => c.id != commentId).toList();
          emit(CommentLoaded(updatedComments));
        }
        deleteCommentBroadcast.add(AsyncState.success(true));
      },
      failure: (message) => deleteCommentBroadcast.add(AsyncState.failure(message)),
    );
  }
}