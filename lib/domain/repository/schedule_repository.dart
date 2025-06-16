


import '../../common/task_result.dart';
import '../model/schedule.dart';

abstract class ScheduleRepository {
  // Get list of schedules
  Future<TaskResult<List<Schedule>>> getSchedules({int? studentId, int? tutorId});

  // Add a new schedule
  Future<TaskResult<Schedule>> addSchedule(Schedule schedule);

  // Update an existing schedule
  Future<TaskResult<Schedule>> updateSchedule(int id, Schedule schedule);

  // Create a new schedule
  Future<TaskResult<bool>> deleteSchedule(int id);


}