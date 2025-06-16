import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../common/utils/time_of_day_conveter.dart';


part 'schedule_slot.freezed.dart';
part 'schedule_slot.g.dart';
@freezed
class ScheduleSlot with _$ScheduleSlot {
  const factory ScheduleSlot(
    int? weekday,
    @JsonKey(name: 'start_time') @TimeOfDayConverter() TimeOfDay? startTime,
    @JsonKey(name: 'end_time') @TimeOfDayConverter() TimeOfDay? endTime,
  ) = _ScheduleSlot;

  factory ScheduleSlot.fromJson(Map<String, dynamic> json) =>
      _$ScheduleSlotFromJson(json);


}


