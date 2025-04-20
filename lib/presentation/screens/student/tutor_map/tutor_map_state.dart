
import '../../../../data/models/users.dart';

abstract class TutorMapState {}
class TutorMapInitial extends TutorMapState {}
class TutorMapLoading extends TutorMapState {}
class TutorMapSuccess extends TutorMapState {

  final List<UserModel> tutors;
  TutorMapSuccess(this.tutors);
}

class TutorMapFailure extends TutorMapState {
  final String message;
  TutorMapFailure(this.message);

}