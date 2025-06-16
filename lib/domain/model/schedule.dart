import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/domain/model/other_user.dart';
import 'package:tutorconnect/domain/model/schedule_slot.dart';
import 'package:tutorconnect/domain/model/student.dart';
import 'package:tutorconnect/domain/model/tutor.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';
@freezed
class Schedule with _$Schedule {
  const factory Schedule(
      int id,
      String? topic,
      String? address,
      DateTime? startDate,
      String? status,
      DateTime? createdAt,
      List<ScheduleSlot> slots,
      Tutor tutor,
      Student student,
      ) = _Schedule;

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}
