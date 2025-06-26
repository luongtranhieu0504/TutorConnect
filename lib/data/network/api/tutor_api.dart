

import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../dto/response_dto.dart';
import '../dto/tutor_dto.dart';

part 'tutor_api.g.dart';

@RestApi()
abstract class TutorApi {
  factory TutorApi(Dio dio) = _TutorApi;

  @GET('/api/tutors/me')
  Future<ResponseDto<TutorDto>> getCurrentTutor();

  // Get list of tutors
  @GET('/api/tutors/flattened')
  Future<ResponseDto<List<TutorDto>>> getTutorsList();

  // Update tutor
  @PUT('/api/tutors/{id}')
  Future<ResponseDto<TutorDto>> updateTutor(
    @Path('id') int id,
    @Body() Map<String, dynamic> data,
  );

  // Get tutor by ID
  @GET('/api/tutors/{id}')
  Future<ResponseDto<TutorDto>> getTutorById(@Path('id') int id);


  @GET('/api/tutors')
  Future<ResponseDto<List<TutorDto>>> getTutors({
    @Query('filters[subjects][\$contains]') String? subject,
  });

}