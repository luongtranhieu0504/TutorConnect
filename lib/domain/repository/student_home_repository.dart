import 'package:tutorconnect/common/task_result.dart';

import '../../domain/model/student.dart';

abstract interface class StudentHomeRepository {
  Future<TaskResult<Student?>> getStudentById(int id);
  Future<TaskResult<Student?>> getCurrentStudent();
  Future<TaskResult<Student?>> updateStudent(int id, Map<String, dynamic> data);

  Future<TaskResult<Student>> updateFavoriteTutors({ required int studentId,required List<int> favoriteTutorId});
}