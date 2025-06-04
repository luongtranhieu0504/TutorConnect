
import '../../../../domain/model/review.dart';

abstract class TutorProfileState {}

class TutorProfileInitial extends TutorProfileState {}
class TutorProfileLoading extends TutorProfileState {}

class TutorProfileSuccess extends TutorProfileState {
  final List<Review> reviews;
  TutorProfileSuccess(this.reviews);
}

class TutorProfileFailure extends TutorProfileState {
  final String message;
  TutorProfileFailure(this.message);
}
