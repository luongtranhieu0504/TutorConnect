import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/domain/model/post.dart';
import 'package:tutorconnect/domain/model/user.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

@freezed
class Comment with _$Comment {
  const factory Comment(
      int id,
      String? content,
      User author,
      Post post,
      ) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}

