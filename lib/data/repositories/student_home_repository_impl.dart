
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/manager/account.dart';
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
      if (!doc.exists) return TaskResult.failure('Student not found');

      final data = doc.data()!;
      final user = UserModel.fromJson({...data, 'uid': studentId});

      // ✅ Save to AppSession
      await Account.instance.saveUser(user);

      return TaskResult.success(user);
    } catch (e) {
      return TaskResult.failure("Error fetching student: $e");
    }
  }

  @override
  Future<TaskResult<bool>> updateStudentHomeData(String studentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(studentId).set(data, SetOptions(merge: true));

      // ✅ Nếu là user hiện tại → update luôn local
      if (Account.instance.user.uid == studentId) {
        final updated = {...Account.instance.user.toJson(), ...data};
        final updatedUser = UserModel.fromJson(updated);
        await Account.instance.saveUser(updatedUser);
      }

      return TaskResult.success(true);
    } catch (e) {
      return TaskResult.failure("Error updating student: $e");
    }
  }

  @override
  Future<TaskResult<bool>> deleteStudentHomeData(String studentId) async {
    try {
      await _firestore.collection('users').doc(studentId).delete();

      // ✅ Nếu là user hiện tại → xoá local luôn
      if (Account.instance.user.uid == studentId) {
        await Account.instance.signOut();
      }

      return TaskResult.success(true);
    } catch (e) {
      return TaskResult.failure("Error deleting student: $e");
    }
  }
}