
import '../../common/task_result.dart';

abstract interface class LoginRepository {
  Future<TaskResult<bool>> signInWithEmail(String email, String password);
  Future<TaskResult<String>> signUpWithEmail({
    required String email,
    required String password,
  });
  Future<TaskResult<bool>> updateUser(String uid, Map<String, dynamic> data);

  Future<TaskResult<bool>> resetPassword(String email);
}