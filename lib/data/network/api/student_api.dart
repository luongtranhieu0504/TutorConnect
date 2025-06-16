
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../dto/response_dto.dart';
import '../dto/student_dto.dart';

part 'student_api.g.dart';

@RestApi()
abstract class StudentApi {
  factory StudentApi(Dio dio) = _StudentApi;

  // Get student by ID
  @GET('/api/students/{id}')
  Future<ResponseDto<StudentDto>> getStudentById(
      @Path('id') int id,
      @Query('populate') String populate,);


  @GET('/api/students/me')
  Future<ResponseDto<StudentDto>> getCurrentStudent();

  // Update student
  @PUT('/api/students/{id}')
  Future<ResponseDto<StudentDto>> updateStudent(
    @Path('id') int id,
    @Body() Map<String, dynamic> data,
  );

  @PUT('/api/students/{id}/update-favorites')
  Future<ResponseDto<StudentDto>> updateFavoriteTutors(
      @Path('id') int id,
      @Body() Map<String, dynamic> data,
  );

  // Your existing methods
}

