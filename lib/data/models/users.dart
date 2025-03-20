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
    );
  }
}
