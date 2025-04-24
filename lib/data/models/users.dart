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
  final String status;
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
    this.status = "offline",
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
      "status": status,
      'studentProfile': studentProfile?.toJson(),
      'tutor_profile': tutorProfile?.toJson(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final tutorProfileRaw = json['tutorProfile'];

    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      name: json['name'],
      school: json['school'],
      grade: json['grade'],
      phone: json['phone'],
      photoUrl: json['photoUrl'],
      bio: json['bio'],
      address: json['address'],
      status: json['status'] ?? 'offline',
      studentProfile: json['studentProfile'] is Map<String, dynamic>
          ? StudentProfile.fromJson(json['studentProfile'])
          : null,
      tutorProfile: tutorProfileRaw is Map<String, dynamic>
          ? TutorProfile.fromJson(tutorProfileRaw)
          : null,
    );
  }
}

extension UserModelCopyWith on UserModel {
  UserModel copyWith({
    StudentProfile? studentProfile, required String status,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      role: role,
      name: name,
      school: school,
      grade: grade,
      phone: phone,
      photoUrl: photoUrl,
      bio: bio,
      address: address,
      status: status,
      studentProfile: studentProfile ?? this.studentProfile,
      tutorProfile: tutorProfile,
    );
  }
}
