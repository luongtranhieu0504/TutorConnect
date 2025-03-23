import 'package:tutorconnect/data/models/session.dart';

class StudentProfile {
  final List<String> favorites;
  final List<SessionModel> learningHistory;

  StudentProfile({
    required this.favorites,
    required this.learningHistory,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      favorites: List<String>.from(json['favorites']),
      learningHistory: (json['learning_history'] as List)
          .map((e) => SessionModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favorites': favorites,
      'learning_history': learningHistory.map((e) => e.toJson()).toList(),
    };
  }
}

