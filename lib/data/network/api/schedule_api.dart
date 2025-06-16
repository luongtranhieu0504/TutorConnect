

import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../dto/response_dto.dart';
import '../dto/schedule_dto.dart';

part 'schedule_api.g.dart';


@RestApi()
abstract class ScheduleApi {
  factory ScheduleApi(Dio dio) = _ScheduleApi;

  // Get schedule by student ID
  @GET('/api/my-schedules')
  Future<ResponseDto<List<ScheduleDto>>> getSchedules({
    @Query('studentId') int? studentId,
    @Query('tutorId') int? tutorId,
  });

  // Update schedule
  @PUT('/api/schedules/{id}')
  Future<ResponseDto<ScheduleDto>> updateSchedule(
    @Path('id') int id,
    @Body() Map<String, dynamic> data,
  );

  @POST('/api/schedules')
  Future<ResponseDto<ScheduleDto>> createSchedule(
    @Body() Map<String, dynamic> data,
  );

  //delete schedule
  @DELETE('/api/schedules/{id}')
  Future<ResponseDto<void>> deleteSchedule(
    @Path('id') int id,
  );
}