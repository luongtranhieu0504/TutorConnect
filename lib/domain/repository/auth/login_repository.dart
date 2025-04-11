
import 'package:tutorconnect/data/models/users.dart';

import '../../../common/task_result.dart';

abstract interface class LoginRepository {
  Future<TaskResult<UserModel>> signInWithEmail(String email, String password);
  Future<TaskResult<String>> signUpWithEmail({
    required String email,
    required String password,
    required String? role,
  });
  Future<TaskResult<bool>> updateUser(String uid, Map<String, dynamic> data);

  Future<TaskResult<bool>> resetPassword(String email);

  Future<TaskResult<bool>> logout();
}