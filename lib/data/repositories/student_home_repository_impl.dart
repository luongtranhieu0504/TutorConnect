import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/mapper/student_mapper.dart';
import '../../common/task_result.dart';
import '../../domain/model/student.dart';
import '../../domain/repository/student_home_repository.dart';
import '../manager/account.dart';
import '../network/api_call.dart';
import '../source/student_network_data_source.dart';

@Singleton(as: StudentHomeRepository)
class StudentHomeRepositoryImpl implements StudentHomeRepository {
  final StudentNetworkDataSource _dataSource;

  StudentHomeRepositoryImpl(this._dataSource);

  @override
  Future<TaskResult<Student?>> getStudentById(int id) =>
      callApi(() async {
        final response = await _dataSource.getStudentById(id);
        return response.data!.toModel();
      });

  @override
  Future<TaskResult<Student?>> updateStudent(int id, Map<String, dynamic> data)  =>
      callApi(() async {
        final response = await _dataSource.updateStudent(id, data);
        return response.data!.toModel();
      });

  @override
  Future<TaskResult<Student>> updateFavoriteTutors({required int studentId, required List<int> favoriteTutorId}) =>
      callApi(() async {
        final response = await _dataSource.updateFavoriteTutors(studentId, favoriteTutorId);
        final student = response.data!.toModel();

        // Update cache if needed
        if (Account.instance.student?.id == studentId) {
          Account.instance.saveStudent(student);
        }
        return student;
      });

  @override
  Future<TaskResult<Student?>> getCurrentStudent() =>
      callApi(() async {
        // If we already have student data cached, return it
        if (Account.instance.student != null) {
          return Account.instance.student;
        }

        // Otherwise fetch from network
        final response = await _dataSource.getCurrentStudent();
        final student = response.data!.toModel();

        // Cache the student data
        Account.instance.saveStudent(student);

        return student;
      });

  Future<TaskResult<Student?>> refreshCurrentStudent() =>
      callApi(() async {
        final response = await _dataSource.getCurrentStudent();
        final student = response.data!.toModel();
        Account.instance.saveStudent(student);
        return student;
      });

}