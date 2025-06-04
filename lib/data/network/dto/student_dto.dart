import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/data/network/dto/review_dto.dart';
import 'package:tutorconnect/data/network/dto/schedule_dto.dart';
import 'package:tutorconnect/data/network/dto/tutor_dto.dart';
import 'package:tutorconnect/data/network/dto/user_dto.dart';

import 'conversation_dto.dart';

part 'student_dto.freezed.dart';
part 'student_dto.g.dart';

@freezed
class StudentDto with _$StudentDto {
  const factory StudentDto({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'uid') String? uid,
    @JsonKey(name: 'user') UserDto? user,
    @JsonKey(name: 'favorites') List<int  >? favorites,
    @JsonKey(name: 'learning_history') List<ScheduleDto>? learningHistory,
    @JsonKey(name: 'reviews') List<ReviewDto>? reviews,
    @JsonKey(name: 'conversations') List<ConversationDto>? conversations,
  }) = _StudentDto;

  factory StudentDto.fromJson(Map<String, dynamic> json) =>
      _$StudentDtoFromJson(json);
}