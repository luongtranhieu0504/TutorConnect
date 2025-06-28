import '../../common/task_result.dart';
import '../model/tutor.dart';

abstract interface class TutorRepository {
  /// Get the current tutor.
  Future<TaskResult<Tutor?>> getCurrentTutor();





  Future<TaskResult<List<Tutor>>> getTutors({
    String? subject,
    bool topRated = false,
  });

  /// Get a tutor by their ID.
  Future<TaskResult<Tutor?>> getTutorById(int id);

  /// Update the tutor's information.
  Future<TaskResult<Tutor?>> updateTutor(int id, Map<String, dynamic> data);

  /// Get tutors by subject.
}