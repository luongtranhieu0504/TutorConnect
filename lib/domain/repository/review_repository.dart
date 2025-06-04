
import '../../common/task_result.dart';
import '../model/review.dart';

abstract class ReviewRepository {
  // Get list of reviews
  Future<TaskResult<List<Review>>> getReviewsList(int tutorId);

  // Add a new review
  Future<TaskResult<Review>> addReview(Review review);

  // Update an existing review
  Future<TaskResult<Review>> updateReview(int id, Review review);

  // Delete a review
  Future<TaskResult<void>> deleteReview(int id);
}