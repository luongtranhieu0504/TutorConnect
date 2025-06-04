import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/data/network/dto/user_dto.dart';

import 'comment_dto.dart';

part 'post_dto.freezed.dart';
part 'post_dto.g.dart';

@freezed
class PostDto with _$PostDto {
  const factory PostDto({
    @JsonKey(name: 'id') int? id,

    @JsonKey(name: 'content') String? content,
    @JsonKey(name: 'imageUrls') List<String>? imageUrls,

    @JsonKey(name: 'author') UserDto? author,
    @JsonKey(name: 'liked_by') List<UserDto>? likedBy,

    @JsonKey(name: 'like_count') int? likeCount,
    @JsonKey(name: 'comment_count') int? commentCount,

    @JsonKey(name: 'comments') List<CommentDto>? comments,
  }) = _PostDto;

  factory PostDto.fromJson(Map<String, dynamic> json) =>
      _$PostDtoFromJson(json);
}