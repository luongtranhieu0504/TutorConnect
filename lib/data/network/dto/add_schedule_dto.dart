

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/data/network/dto/schedule_slot_dto.dart';
import 'package:tutorconnect/data/network/dto/student_dto.dart';
import 'package:tutorconnect/data/network/dto/tutor_dto.dart';

import '../../../domain/model/schedule_slot.dart';
import '../../../domain/model/student.dart';
import '../../../domain/model/tutor.dart';

part 'add_schedule_dto.freezed.dart';
part 'add_schedule_dto.g.dart';


@freezed
class AddScheduleDto with _$AddScheduleDto {
  const factory AddScheduleDto({
    @JsonKey(name: 'topic') String? topic,
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'status') String? status, // enum string
    @JsonKey(name: 'created_at') DateTime? createdAt,

    @JsonKey(name: 'slots') List<ScheduleSlot>? slots,

    @JsonKey(name: 'tutor') int? tutor,
    @JsonKey(name: 'student') int? student,
  }) = _AddScheduleDto;

  factory AddScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$AddScheduleDtoFromJson(json);
}

extension AddScheduleDtoJsonConverter on AddScheduleDto {
  Map<String, dynamic> toStrapiJson() {
    return {
      'data': toJson(),
    };
  }
}