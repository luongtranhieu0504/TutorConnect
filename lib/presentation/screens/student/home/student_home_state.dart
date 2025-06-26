
import 'package:tutorconnect/domain/model/student.dart';

import '../../../../domain/model/tutor.dart';
import '../../../../domain/model/user.dart';

abstract class StudentHomeState {}

class Initial extends StudentHomeState {}

class Loading extends StudentHomeState {}

class Success extends StudentHomeState {
  final Student student;
  final List<Tutor> tutors;
  Success(this.student, this.tutors);
}

class Failure extends StudentHomeState {
  final String message;
  Failure(this.message);
}
