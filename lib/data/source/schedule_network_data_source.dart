

import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/network/dto/add_schedule_dto.dart';

import '../network/api/schedule_api.dart';
import '../network/dto/response_dto.dart';
import '../network/dto/schedule_dto.dart';

@singleton
class ScheduleNetworkDataSource {
  final ScheduleApi _scheduleApi;

  ScheduleNetworkDataSource(this._scheduleApi);

  Future<ResponseDto<List<ScheduleDto>>> getSchedules({int? studentId, int? tutorId}) => _scheduleApi.getSchedules(
        studentId: studentId,
        tutorId: tutorId,
      );

  Future<ResponseDto<ScheduleDto>> updateSchedule(int id, Map<String, dynamic> data) => _scheduleApi.updateSchedule(
    id, {
    'data': data,
    }
  );

  Future<ResponseDto<ScheduleDto>> createSchedule(AddScheduleDto addScheduleDto) => _scheduleApi.createSchedule(addScheduleDto.toStrapiJson());

  Future<ResponseDto<void>> deleteSchedule(int id) => _scheduleApi.deleteSchedule(id);
}