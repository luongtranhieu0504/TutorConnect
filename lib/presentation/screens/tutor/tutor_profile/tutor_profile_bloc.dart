
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/common/stream_wrapper.dart';

import 'package:tutorconnect/domain/repository/tutor_profile_repository.dart';
import 'package:tutorconnect/presentation/screens/tutor/tutor_profile/tutor_profile_state.dart';
import '../../../../common/async_state.dart';
import '../../../../data/models/reviews.dart';
import '../../../../data/models/tutor.dart';

@injectable
class TutorProfileBloc extends Cubit<TutorProfileState> {
  final TutorProfileRepository _tutorProfileRepository;

  final addBroadcast = StreamWrapper<AsyncState<void>>(broadcast: true);
  final addFavoriteBroadcast = StreamWrapper<AsyncState<void>>(broadcast: true);
  TutorProfileBloc(this._tutorProfileRepository) : super(TutorProfileInitial());

  void getTutorProfile(String uid) async {
    emit(TutorProfileLoading());
    final result = await _tutorProfileRepository.getReviews(uid);
    result.when(
      success: (reviews) => emit(TutorProfileSuccess(reviews)),
      failure: (message) => emit(TutorProfileFailure(message)),
    );
  }

  void addReview ({
    required String tutorId,
    required String studentId,
    required String studentName,
    required double rating,
    required String comment,
  }) async {
    addBroadcast.add(AsyncState.loading());
    final review = ReviewModel(
      id: '',
      tutorId: tutorId,
      studentId: studentId,
      studentName: studentName,
      rating: rating.toInt(),
      comment: comment,
      date: DateTime.now(),
    );
    final result = await _tutorProfileRepository.addReview(review);
    result.when(
      success: (_) => addBroadcast.add(AsyncState.success(null)),
      failure: (message) => addBroadcast.add(AsyncState.failure(message)),
    );
  }

  void addFavoriteTutor({
    required String studentId,
    required String tutorId,
  }) async {
    addFavoriteBroadcast.add(AsyncState.loading());
    final result = await _tutorProfileRepository.addFavoriteTutor(
      studentId: studentId,
      tutorId: tutorId,
    );
    result.when(
      success: (_) => addFavoriteBroadcast.add(AsyncState.success(null)),
      failure: (message) => addFavoriteBroadcast.add(AsyncState.failure(message)),
    );
  }

}
