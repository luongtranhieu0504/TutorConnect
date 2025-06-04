
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tutorconnect/data/network/dto/add_review_dto.dart';

import '../dto/response_dto.dart';
import '../dto/review_dto.dart';

part 'review_api.g.dart';

@RestApi()
abstract class ReviewApi {
  factory ReviewApi(Dio dio) = _ReviewApi;

  // Get list of reviews
  @GET('/api/reviews/flat?tutorId={id}')
  Future<ResponseDto<List<ReviewDto>>> getReviewsList(
    @Path('id') int tutorId
  );

  // Add a new review
  @POST('/api/reviews')
  Future<ResponseDto<ReviewDto>> addReview(
      @Body() Map<String, dynamic> reviewDto,
      );

  // Update an existing review
  @PUT('/api/reviews/{id}')
  Future<ResponseDto<ReviewDto>> updateReview(
    @Path('id') int id,
    @Body() ReviewDto reviewDto,
  );

  // Delete a review
  @DELETE('/api/reviews/{id}')
  Future<ResponseDto<void>> deleteReview(
    @Path('id') int id,
  );
}