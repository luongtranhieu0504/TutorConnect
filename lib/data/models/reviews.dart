import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String tutorId;
  final String studentId;
  final String studentName;
  final int rating;
  final String comment;
  final DateTime date;

  ReviewModel({
    required this.id,
    required this.tutorId,
    required this.studentId,
    required this.studentName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ReviewModel.fromJson(String id, Map<String, dynamic> json) {
    return ReviewModel(
      id: id,
      tutorId: json['tutorId'],
      studentId: json['studentId'],
      studentName: json['studentName'] ?? '',
      rating: json['rating'],
      comment: json['comment'],
      date: json['date'] is Timestamp
          ? (json['date'] as Timestamp).toDate()
          : DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'tutorId': tutorId,
    'studentId': studentId,
    'studentName': studentName,
    'rating': rating,
    'comment': comment,
    'date': date.toIso8601String(),
  };
}
