import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/data/network/dto/other_user_dto.dart';
import 'package:tutorconnect/domain/model/schedule.dart';
import 'tutor_dto.dart';
import 'student_dto.dart';
import 'schedule_slot_dto.dart';

part 'schedule_dto.freezed.dart';
part 'schedule_dto.g.dart';

@freezed
class ScheduleDto with _$ScheduleDto {
  const factory ScheduleDto({
    @JsonKey(name: 'id') int? id,

    @JsonKey(name: 'topic') String? topic,
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'status') String? status, // enum string
    @JsonKey(name: 'created_at') DateTime? createdAt,

    @JsonKey(name: 'slots') List<ScheduleSlotDto>? slots,

    @JsonKey(name: 'tutor') TutorDto? tutor,
    @JsonKey(name: 'student') StudentDto? student,
  }) = _ScheduleDto;

  factory ScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDtoFromJson(json);

}
