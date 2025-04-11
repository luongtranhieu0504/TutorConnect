
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../common/task_result.dart';
import '../../domain/repository/student_home_repository.dart';
import '../models/users.dart';

@Injectable(as: StudentHomeRepository)
class StudentHomeRepositoryImpl implements StudentHomeRepository {
  final FirebaseFirestore _firestore;

  StudentHomeRepositoryImpl(this._firestore);

  @override
  Future<TaskResult<UserModel?>> getStudentById(String studentId) async {
    try {
      final doc = await _firestore.collection('users').doc(studentId).get();
      if (doc.exists) {
        return TaskResult.success(UserModel.fromJson(doc.data()!));
      } else {
        return TaskResult.failure('Student not found');
      }
    } catch (e) {
      return TaskResult.failure(e.toString());
    }
  }

  @override
  Future<TaskResult<bool>> updateStudentHomeData(String studentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('students').doc(studentId).update(data);
      return TaskResult.success(true);
    } catch (e) {
      return TaskResult.failure(e.toString());
    }
  }

  @override
  Future<TaskResult<bool>> deleteStudentHomeData(String studentId) async {
    try {
      await _firestore.collection('students').doc(studentId).delete();
      return TaskResult.success(true);
    } catch (e) {
      return TaskResult.failure(e.toString());
    }
  }
}