import 'package:tutorconnect/data/mapper/schedule_slot_mapper.dart';
import 'package:tutorconnect/data/mapper/student_mapper.dart';
import 'package:tutorconnect/data/mapper/tutor_mapper.dart';

import '../../domain/model/schedule.dart';
import '../network/dto/schedule_dto.dart';

extension ScheduleDtoExtension on ScheduleDto {
  Schedule toModel() {
    return Schedule(
      id ?? 0,
      topic,
      address,
      startDate,
      status,
      createdAt,
      slots?.map((e) => e.toModel()).toList() ?? [],
      tutor!.toModel(),
      student!.toModel(),
    );
  }
}
