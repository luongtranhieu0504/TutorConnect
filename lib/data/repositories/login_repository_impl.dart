import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../common/task_result.dart';
import '../../domain/repository/login_repository.dart';

@Injectable(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<TaskResult<bool>> signInWithEmail(String email,String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      // final User? user = credential.user;
      // if (user == null) {
      //   return TaskResult.failure("User not found");
      // }
      // DocumentSnapshot userSnapshot = await _firestore.collection('users').doc(user.uid).get();
      // if (!userSnapshot.exists) {
      //   return TaskResult.failure("User not found");
      // }
      // UserModel loggedInUser = UserModel.fromJson(userSnapshot.data() as Map<String, dynamic>);
      if (credential.user != null) {
        return TaskResult.success(true); // ✅ Chỉ xác thực đăng nhập, không cần lấy user
      } else {
        return TaskResult.failure("Authentication failed");
      }
    } catch (e) {
      return TaskResult.failure("Unexpected error: $e");
    }
  }

  @override
  Future<TaskResult<bool>> resetPassword(String email) async{
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return TaskResult.success(true);
    } on FirebaseAuthException catch (e) {
      return TaskResult.failure(_handleAuthError(e.code));
    }
    catch (e) {
      return TaskResult.failure(e.toString());
    }
  }

  String _handleAuthError(String code) {
    switch (code) {
      case "user-not-found":
        return "Email chưa được đăng ký.";
      case "invalid-email":
        return "Email không hợp lệ.";
      default:
        return "Lỗi đăng nhập.";
    }
  }

  @override
  Future<TaskResult<String>> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return TaskResult.failure("User creation failed.");
      }
      return TaskResult.success(user.uid);

    } on FirebaseAuthException catch (e) {
      return TaskResult.failure("Registration failed: ${e.message}");
    } catch (e) {
      return TaskResult.failure("Unexpected error during registration: $e");
    }
  }


  @override
  Future<TaskResult<bool>> updateUser(String uid, Map<String, dynamic> data) async {
    if (data['role'] == null || (data['role'] as String).isEmpty) {
      return TaskResult.failure("Vai trò (Role) là bắt buộc.");
    }
    try {
      await _firestore.collection("users").doc(uid).set(data, SetOptions(merge: true));
      return TaskResult.success(true);
    } catch (e) {
      return TaskResult.failure("Unexpected error while updating user details: $e");
    }
  }
}
