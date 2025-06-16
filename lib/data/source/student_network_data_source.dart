import 'package:injectable/injectable.dart';
import '../network/api/student_api.dart';
import '../network/dto/response_dto.dart';
import '../network/dto/student_dto.dart';

@singleton
class StudentNetworkDataSource {
  final StudentApi _studentApi;

  StudentNetworkDataSource(this._studentApi);

  Future<ResponseDto<StudentDto>> getStudentById(int id) => _studentApi.getStudentById(id, 'user');

  Future<ResponseDto<StudentDto>> getCurrentStudent() => _studentApi.getCurrentStudent();

  Future<ResponseDto<StudentDto>> updateStudent(int id, Map<String, dynamic> data) => _studentApi.updateStudent(id, data);

  Future<ResponseDto<StudentDto>> updateFavoriteTutors(int studentId, List<int> tutorIds) =>
      _studentApi.updateFavoriteTutors(studentId, {"favorites": tutorIds});

}