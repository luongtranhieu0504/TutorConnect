
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/common/task_result.dart';
import 'package:tutorconnect/data/models/reviews.dart';
import 'package:tutorconnect/data/models/users.dart';
import '../../domain/repository/tutor_profile_repository.dart';
import '../manager/account.dart';

@Injectable(as: TutorProfileRepository)
class TutorProfileRepositoryImpl implements TutorProfileRepository {
  final FirebaseFirestore _firestore;

  TutorProfileRepositoryImpl(this._firestore);

  @override
  Future<TaskResult<void>> addReview(ReviewModel review,) async {
    try {
      final ref = _firestore.collection('reviews').doc();
      await ref.set(review.toJson());
      return TaskResult.success(null);
    } catch (e) {
      return TaskResult.failure(e.toString());
    }
  }

  @override
  Future<TaskResult<List<ReviewModel>>> getReviews(String tutorId) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('tutorId', isEqualTo: tutorId)
          .get();

      final reviews = snapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.id, doc.data()))
          .toList();

      return TaskResult.success(reviews);
    } catch (e) {
      return TaskResult.failure(e.toString());
    }
  }

  @override
  Future<TaskResult<void>> addFavoriteTutor({
    required String studentId,
    required String tutorId,
  }) async {
    try {
      // Fetch current favorites directly
      final docRef = _firestore.collection('users').doc(studentId);
      final snapshot = await docRef.get();

      if (!snapshot.exists) return TaskResult.failure("Student not found");

      final data = snapshot.data();
      final studentProfile = data?['studentProfile'] as Map<String, dynamic>?;

      List<String> favorites = List<String>.from(
        studentProfile?['favorites'] ?? [],
      );
      // Add if not already favorite
      if (!favorites.contains(tutorId)) {
        favorites.add(tutorId);
        await docRef.update({'studentProfile.favorites': favorites});
      }

      // Update local session if applicable
      if (Account.instance.user.uid == studentId) {
        final currentUser = Account.instance.user;
        final updatedUser = currentUser.copyWith(
          studentProfile: currentUser.studentProfile?.copyWith(
            favorites: favorites,
          ), status: '',
        );
        await Account.instance.saveUser(updatedUser);
      }

      return TaskResult.success(null);
    } catch (e) {
      return TaskResult.failure(e.toString());
    }
  }

}