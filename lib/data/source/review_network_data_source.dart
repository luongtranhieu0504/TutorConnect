// lib/data/source/review_network_data_source.dart
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/network/api/review_api.dart';
import 'package:tutorconnect/data/network/dto/add_review_dto.dart';
import 'package:tutorconnect/data/network/dto/response_dto.dart';
import 'package:tutorconnect/data/network/dto/review_dto.dart';

@singleton
class ReviewNetworkDataSource {
  final ReviewApi _reviewApi;

  ReviewNetworkDataSource(this._reviewApi);

  Future<ResponseDto<List<ReviewDto>>> getReviewsList(int tutorId) async {
    return _reviewApi.getReviewsList(tutorId);
  }

  Future<ResponseDto<ReviewDto>> addReview(AddReviewDto reviewDto) => _reviewApi.addReview(reviewDto.toStrapiJson());

  Future<ResponseDto<ReviewDto>> updateReview(int id, ReviewDto reviewDto) async {
    return _reviewApi.updateReview(id, reviewDto);
  }

  Future<ResponseDto<void>> deleteReview(int id) async {
    return _reviewApi.deleteReview(id);
  }
}