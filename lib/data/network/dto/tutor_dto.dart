import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/data/network/dto/review_dto.dart';
import 'package:tutorconnect/data/network/dto/schedule_dto.dart';
import 'package:tutorconnect/data/network/dto/schedule_slot_dto.dart';
import 'package:tutorconnect/data/network/dto/user_dto.dart';

import 'certification_dto.dart';
import 'conversation_dto.dart';

part 'tutor_dto.freezed.dart';
part 'tutor_dto.g.dart';

@freezed
class TutorDto with _$TutorDto {
  const factory TutorDto({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'uid') String? uid,
    @JsonKey(name: 'user') UserDto? user,
    @JsonKey(name: 'schedules') List<ScheduleDto>? schedules,
    @JsonKey(name: 'reviews') List<ReviewDto>? reviews,
    @JsonKey(name: 'conversations') List<ConversationDto>? conversations,
    @JsonKey(name: 'subjects') List<String>? subjects,
    @JsonKey(name: 'degrees') List<String>? degrees,
    @JsonKey(name: 'experienceYears') int? experienceYears,
    @JsonKey(name: 'pricePerHour') int? pricePerHour,
    @JsonKey(name: 'availability') List<ScheduleSlotDto>? availability,
    @JsonKey(name: 'bio') String? bio,
    @JsonKey(name: 'rating') double? rating,
    @JsonKey(name: 'certifications') List<CertificationDto>? certifications,
  }) = _TutorDto;

  factory TutorDto.fromJson(Map<String, dynamic> json) =>
      _$TutorDtoFromJson(json);
}