import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/data/network/dto/user_dto.dart';
import 'post_dto.dart';

part 'comment_dto.freezed.dart';
part 'comment_dto.g.dart';

@freezed
class CommentDto with _$CommentDto {
  const factory CommentDto({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'content') String? content,
    @JsonKey(name: 'imageUrls') List<String>? imageUrls,
    @JsonKey(name: 'author') UserDto? author,
    @JsonKey(name: 'post') PostDto? post,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  }) = _CommentDto;

  factory CommentDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoFromJson(json);
}
