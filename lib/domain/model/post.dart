import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/domain/model/user.dart';
import 'comment.dart';


part 'post.freezed.dart';
part 'post.g.dart';
@freezed
class Post with _$Post {
  const factory Post(
      int id,
      String? content,
      List<String>? imageUrls,
      User? author,
      List<User>? likedBy,
      int? likeCount,
      int? commentCount,
      DateTime createdAt,
      List<Comment>? comments,
      ) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) =>
      _$PostFromJson(json);
}
