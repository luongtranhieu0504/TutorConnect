import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/data/network/dto/post_dto.dart';
import 'package:tutorconnect/data/network/dto/role_dto.dart';
import 'package:tutorconnect/data/network/dto/student_dto.dart';
import 'package:tutorconnect/data/network/dto/tutor_dto.dart';

import 'comment_dto.dart';
import 'conversation_dto.dart';
import 'message_dto.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'fcmToken') String? fcmToken,
    @JsonKey(name: 'role') RoleDto? role,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'school') String? school,
    @JsonKey(name: 'grade') String? grade,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'photoUrl') String? photoUrl,
    @JsonKey(name: 'bio') dynamic bio, // blocks, có thể là List hoặc Map tùy dữ liệu
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'state') String? state,
    @JsonKey(name: 'type_role') String? typeRole,
    @JsonKey(name: 'student') StudentDto? student,
    @JsonKey(name: 'tutor') TutorDto? tutor,
    @JsonKey(name: 'sentMessages') List<MessageDto>? sentMessages,
    @JsonKey(name: 'receivedMessages') List<MessageDto>? receivedMessages,
    @JsonKey(name: 'posts') List<PostDto>? posts,
    @JsonKey(name: 'comments') List<CommentDto>? comments,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}