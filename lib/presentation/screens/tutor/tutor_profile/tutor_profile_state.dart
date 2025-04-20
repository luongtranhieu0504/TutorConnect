

import 'package:tutorconnect/data/models/reviews.dart';
import 'package:tutorconnect/data/models/tutor.dart';

abstract class TutorProfileState {}

class TutorProfileInitial extends TutorProfileState {}
class TutorProfileLoading extends TutorProfileState {}

class TutorProfileSuccess extends TutorProfileState {
  final List<ReviewModel> reviews;
  TutorProfileSuccess(this.reviews);
}

class TutorProfileFailure extends TutorProfileState {
  final String message;
  TutorProfileFailure(this.message);
}
