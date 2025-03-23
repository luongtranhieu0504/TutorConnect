import 'dart:convert';
import 'package:tutorconnect/data/models/student.dart';
import 'package:tutorconnect/data/models/tutor.dart';

class UserModel {
  final String uid;
  final String email;
  final String role;
  final String? name;
  final String? school;
  final String? grade;
  final String? phone;
  final String? photoUrl;
  final String? bio;
  final String? address;
  final StudentProfile? studentProfile;
  final TutorProfile? tutorProfile;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.name,
    this.school,
    this.grade,
    this.phone,
    this.photoUrl,
    this.bio,
    this.address,
    this.studentProfile,
    this.tutorProfile,
  });

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "email": email,
      "role": role,
      "name": name ?? "",
      "school": school ?? "",
      "grade": grade ?? "",
      "phone": phone ?? "",
      "photoUrl": photoUrl ?? "",
      "bio": bio ?? "",
      "address": address ?? "",
      'student_profile': studentProfile?.toJson(),
      'tutor_profile': tutorProfile?.toJson(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"],
      email: json["email"],
      role: json["role"],
      name: json["name"],
      school: json["school"],
      grade: json["grade"],
      phone: json["phone"],
      photoUrl: json["photoUrl"],
      bio: json["bio"],
      address: json["address"],
      studentProfile: json['student_profile'] != null
          ? StudentProfile.fromJson(json['student_profile'])
          : null,
      tutorProfile: json['tutor_profile'] != null
          ? TutorProfile.fromJson(json['tutor_profile'])
          : null,
    );
  }
}
