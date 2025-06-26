import 'dart:io';


import 'package:tutorconnect/domain/model/user.dart';

import '../../common/task_result.dart';
abstract interface class AuthRepository {
  Future<TaskResult<bool>> signIn(String identifier, String password);
  Future<TaskResult<bool>> register(String username, String email, String password, int role);
  Future<TaskResult<bool>> logout();
  Future<TaskResult<User>> updateUser(int id, User user);

  Future<TaskResult<void>> saveFcmToken(String? token);

  Future<TaskResult<User?>> getUserById(int id);

}