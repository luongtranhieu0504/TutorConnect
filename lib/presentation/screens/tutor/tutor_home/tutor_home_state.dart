
import '../../../../domain/model/tutor.dart';

abstract class TutorHomeState {}

class Initial extends TutorHomeState {}

class Loading extends TutorHomeState {}

class Success extends TutorHomeState {
  final Tutor tutor;

  Success(this.tutor);

}

class Failure extends TutorHomeState {
  final String message;

  Failure(this.message);
}