
import '../../common/task_result.dart';
import '../../data/models/users.dart';

abstract interface class StudentHomeRepository {
  Future<TaskResult<UserModel?>> getStudentById(String studentId);
  Future<TaskResult<bool>> updateStudentHomeData(String studentId, Map<String, dynamic> data);
  Future<TaskResult<bool>> deleteStudentHomeData(String studentId);
}