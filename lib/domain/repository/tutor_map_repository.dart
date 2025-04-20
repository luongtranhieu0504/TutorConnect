
import 'package:tutorconnect/data/models/users.dart';

import '../../common/task_result.dart';

abstract interface class TutorMapRepository {
  Future<TaskResult<List<UserModel>>> getTutors();
}