
import 'package:tutorconnect/domain/model/student.dart';

import '../../../../domain/model/user.dart';

abstract class StudentHomeState {}

class Initial extends StudentHomeState {}

class Loading extends StudentHomeState {}

class Success extends StudentHomeState {
  final Student student;
  Success(this.student);
}

class Failure extends StudentHomeState {
  final String message;
  Failure(this.message);
}
