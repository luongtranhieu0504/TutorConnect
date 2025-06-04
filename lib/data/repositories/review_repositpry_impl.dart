import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/mapper/review_mapper.dart';
import 'package:tutorconnect/data/network/dto/add_review_dto.dart';
import 'package:tutorconnect/data/network/dto/review_dto.dart';
import 'package:tutorconnect/data/source/review_network_data_source.dart';
import 'package:tutorconnect/domain/repository/review_repository.dart';

import '../../common/task_result.dart';
import '../../domain/model/review.dart';
import '../network/api_call.dart';

@Singleton(as: ReviewRepository)
class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewNetworkDataSource _dataSource;

  ReviewRepositoryImpl(this._dataSource);

  @override
  Future<TaskResult<List<Review>>> getReviewsList(int tutorId) => callApi(() async {
    final response = await _dataSource.getReviewsList(tutorId);
    return response.data?.map((dto) => dto.toModel()).toList() ?? [];
  });

  @override
  Future<TaskResult<Review>> addReview(Review review) => callApi(() async {
    // Create ReviewDto from Review model
    final reviewDto = AddReviewDto(
      rating: review.rating!,
      comment: review.comment,
      date: review.date!,
      studentName: review.studentName!,
      student: review.student!,
      tutor: review.tutor!,
    );

    final response = await _dataSource.addReview(reviewDto);
    return Review(
      response.data!.id!,
      response.data!.rating,
      response.data!.comment,
      response.data!.date,
      response.data!.student,
      response.data!.tutor,
      response.data!.studentName,
    );
  });

  @override
  Future<TaskResult<Review>> updateReview(int id, Review review) => callApi(() async {
    final reviewDto = ReviewDto(
      id: review.id,
      rating: review.rating,
      comment: review.comment,
      date: review.date,
      studentName: review.studentName,
      student: review.student,
      tutor: review.tutor,
    );

    final response = await _dataSource.updateReview(id, reviewDto);

    return Review(
      response.data!.id ?? 0,
      response.data!.rating,
      response.data!.comment,
      response.data!.date,
      response.data!.student,
      response.data!.tutor,
      response.data!.studentName,
    );
  });

  @override
  Future<TaskResult<void>> deleteReview(int id) => callApi(() async {
    await _dataSource.deleteReview(id);
  });

  // Helper method to wrap API calls with try-catch and convert to TaskResult
  Future<TaskResult<T>> callApi<T>(Future<T> Function() apiCall) async {
    try {
      final result = await apiCall();
      return TaskResult.success(result);
    } catch (e, stackTrace) {
      print('API Error: $e\n$stackTrace');
      return TaskResult.failure(e.toString());
    }
  }
}