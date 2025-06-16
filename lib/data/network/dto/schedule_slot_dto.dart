import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import '../converter/date_time_converter.dart';
part 'schedule_slot_dto.freezed.dart';
part 'schedule_slot_dto.g.dart';

@freezed
class ScheduleSlotDto with _$ScheduleSlotDto {
  const factory ScheduleSlotDto({
    @JsonKey(name: 'weekday') int? weekday,

    @JsonKey(name: 'start_time')
    @TimeOfDayConverter()
    TimeOfDay? startTime,

    @JsonKey(name: 'end_time')
    @TimeOfDayConverter()
    TimeOfDay? endTime,
  }) = _ScheduleSlotDto;

  factory ScheduleSlotDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleSlotDtoFromJson(json);


}


