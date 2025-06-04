import '../../common/task_result.dart';
import '../model/tutor.dart';

abstract interface class TutorRepository {
  /// Get the current tutor.
  Future<TaskResult<Tutor?>> getCurrentTutor();

  /// Get a list of tutors.
  Future<TaskResult<List<Tutor>>> getTutorsList();

  /// Update the tutor's information.
  Future<TaskResult<Tutor?>> updateTutor(int id, Map<String, dynamic> data);
}