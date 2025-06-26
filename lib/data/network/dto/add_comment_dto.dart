

import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_comment_dto.freezed.dart';
part 'add_comment_dto.g.dart';

@freezed
class AddCommentDto with _$AddCommentDto {
  const factory AddCommentDto({
    @JsonKey(name: 'content') String? content,
    @JsonKey(name: 'imageUrls') List<String>? imageUrls, // List of image URLs
    @JsonKey(name: 'post') int? post, // ID of the post
    @JsonKey(name: 'author') int? author, // ID of the user
  }) = _AddCommentDto;

  factory AddCommentDto.fromJson(Map<String, dynamic> json) =>
      _$AddCommentDtoFromJson(json);
}

extension AddCommentDtoJsonConverter on AddCommentDto {
  Map<String, dynamic> toStrapiJson() {
    return {
      'data': toJson(),
    };
  }
}