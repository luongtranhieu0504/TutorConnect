

import 'package:tutorconnect/data/models/reviews.dart';

import '../../common/task_result.dart';

abstract interface class TutorProfileRepository {
  Future<TaskResult<void>> addReview(ReviewModel review);
  Future<TaskResult<List<ReviewModel>>> getReviews(String tutorId);
  Future<TaskResult<void>> addFavoriteTutor({required String studentId, required String tutorId,});

}