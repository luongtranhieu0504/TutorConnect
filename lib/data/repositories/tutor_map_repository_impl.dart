
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../common/task_result.dart';
import '../../domain/repository/tutor_map_repository.dart';
import '../models/users.dart';

@Injectable(as: TutorMapRepository)
class TutorMapRepositoryImpl implements TutorMapRepository {
  final FirebaseFirestore _firestore;

  TutorMapRepositoryImpl(this._firestore);

  @override
  Future<TaskResult<List<UserModel>>> getTutors() async {
    try {
      Query query = _firestore.collection('users').where('role', isEqualTo: "Gia sư");
      final snapshot = await query.get();
      final tutors = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromJson(data);
      }).toList();

      return TaskResult.success(tutors);
    } catch (e) {
      return TaskResult.failure(e.toString());
    }
  }


}