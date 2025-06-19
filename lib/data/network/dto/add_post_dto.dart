

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/model/comment.dart';
import '../../../domain/model/user.dart';


part 'add_post_dto.freezed.dart';
part 'add_post_dto.g.dart';

@freezed
class AddPostDto with _$AddPostDto {
  const factory AddPostDto({
    @JsonKey(name: 'content') String? content,
    @JsonKey(name: 'imageUrls') List<String>? imageUrls,
    @JsonKey(name: 'author') int? author, // ID user
    @JsonKey(name: 'liked_by') List<int>? likedBy, // List ID user
    @JsonKey(name: 'like_count') int? likeCount,
    @JsonKey(name: 'comment_count') int? commentCount,
  }) = _PostDto;

  factory AddPostDto.fromJson(Map<String, dynamic> json) =>
      _$AddPostDtoFromJson(json);
}

extension AddPostDtoJsonConverter on AddPostDto {
  Map<String, dynamic> toStrapiJson() {
    return {
      'data': toJson(),
    };
  }
}