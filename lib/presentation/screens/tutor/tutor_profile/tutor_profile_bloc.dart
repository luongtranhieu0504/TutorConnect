
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/common/stream_wrapper.dart';
import 'package:tutorconnect/domain/model/conversation.dart';
import 'package:tutorconnect/domain/repository/conversation_repository.dart';
import 'package:tutorconnect/domain/repository/review_repository.dart';
import 'package:tutorconnect/domain/repository/student_home_repository.dart';
import 'package:tutorconnect/presentation/screens/tutor/tutor_profile/tutor_profile_state.dart';
import '../../../../common/async_state.dart';
import '../../../../data/manager/account.dart';
import '../../../../domain/model/review.dart';


@injectable
class TutorProfileBloc extends Cubit<TutorProfileState> {
  final ReviewRepository _reviewRepository;
  final StudentHomeRepository _studentHomeRepository;

  final ConversationRepository _conversationRepository;


  final addBroadcast = StreamWrapper<AsyncState<void>>(broadcast: true);
  final addFavoriteBroadcast = StreamWrapper<AsyncState<void>>(broadcast: true);
  final openChatBroadcast = StreamWrapper<AsyncState<Conversation>>(broadcast: true);
  TutorProfileBloc(this._reviewRepository, this._studentHomeRepository, this._conversationRepository) : super(TutorProfileInitial());

  void getReviews(int tutorId) async {
    emit(TutorProfileLoading());
    final result = await _reviewRepository.getReviewsList(tutorId);
    result.when(
      success: (reviews) => emit(TutorProfileSuccess(reviews)),
      failure: (message) => emit(TutorProfileFailure(message)),
    );
  }

  void addReview (
    int tutorId,
    int studentId,
    String studentName,
    int rating,
    String comment,
  ) async {
    addBroadcast.add(AsyncState.loading());
    final review = Review(
      0,
      rating,
      comment,
      DateTime.now(),
      studentId,
      tutorId,
      studentName,
    );
    final result = await _reviewRepository.addReview(review);
    result.when(
      success: (_) => addBroadcast.add(AsyncState.success(null)),
      failure: (message) => addBroadcast.add(AsyncState.failure(message)),
    );
  }

  void deleteReview(int reviewId) async {
    addBroadcast.add(AsyncState.loading());
    final result = await _reviewRepository.deleteReview(reviewId);
    result.when(
      success: (_) => addBroadcast.add(AsyncState.success(null)),
      failure: (message) => addBroadcast.add(AsyncState.failure(message)),
    );
  }

  Future<void> findOrCreateConversation(int studentId, tutorId) async {
    openChatBroadcast.add(AsyncState.loading());

    final result = await _conversationRepository.findOrCreateConversation(
      studentId,
      tutorId,
    );
    result.when(
      success: (conversationId) {
        openChatBroadcast.add(AsyncState.success(conversationId));
      },
      failure: (message) {
        openChatBroadcast.add(AsyncState.failure(message));
      },
    );
  }

  void addFavoriteTutor({
    required int studentId,
    required List<int> tutorId,
  }) async {
    addFavoriteBroadcast.add(AsyncState.loading());
    final result = await _studentHomeRepository.updateFavoriteTutors(
      studentId: studentId,
      favoriteTutorId: tutorId,
    );
    result.when(
      success: (_) => addFavoriteBroadcast.add(AsyncState.success(null)),
      failure: (message) => addFavoriteBroadcast.add(AsyncState.failure(message)),
    );
  }

}
