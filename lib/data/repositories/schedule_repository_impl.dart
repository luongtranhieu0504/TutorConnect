

import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/mapper/schedule_mapper.dart';
import 'package:tutorconnect/data/mapper/schedule_slot_mapper.dart';
import 'package:tutorconnect/data/mapper/student_mapper.dart';
import 'package:tutorconnect/data/mapper/tutor_mapper.dart';
import 'package:tutorconnect/data/network/dto/add_schedule_dto.dart';

import '../../common/task_result.dart';
import '../../domain/model/schedule.dart';
import '../../domain/repository/schedule_repository.dart';
import '../network/api_call.dart';
import '../source/schedule_network_data_source.dart';

@Singleton(as: ScheduleRepository)
class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleNetworkDataSource _dataSource;

  ScheduleRepositoryImpl(this._dataSource);

  @override
  Future<TaskResult<Schedule>> addSchedule(Schedule schedule) => callApi(() async {
    final addScheduleDto = AddScheduleDto(
      topic: schedule.topic,
      address: schedule.address,
      startDate: schedule.startDate,
      status: schedule.status,
      createdAt: schedule.createdAt,
      slots: schedule.slots,
      tutor: schedule.tutor.id,
      student: schedule.student.id,
    );
    final response = await _dataSource.createSchedule(addScheduleDto);
    return response.data!.toModel();
  });

  @override
  Future<TaskResult<List<Schedule>>> getSchedules({int? studentId, int? tutorId}) async {
    return callApi(() async {
      final response = await _dataSource.getSchedules(studentId: studentId, tutorId: tutorId);
      return response.data!.map((dto) => dto.toModel()).toList();
    });
  }

  @override
  Future<TaskResult<Schedule>> updateSchedule(int id, Schedule schedule) => callApi(() async {
    final updateData = {
      'topic': schedule.topic,
      'address': schedule.address,
      'start_date': schedule.startDate?.toIso8601String(),
      'status': schedule.status,
      'slots': schedule.slots.map((slot) => slot.toJson()).toList(),
    };
    final response = await _dataSource.updateSchedule(id, updateData);
    return response.data!.toModel();
  });

  @override
  Future<TaskResult<bool>> deleteSchedule(int id) => callApi(() async {
    await _dataSource.deleteSchedule(id);
    return true;
  });
}