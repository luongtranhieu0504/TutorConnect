import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/domain/model/review.dart';
import 'package:tutorconnect/domain/model/schedule.dart';
import 'package:tutorconnect/domain/model/tutor.dart';
import 'package:tutorconnect/domain/model/user.dart';

import 'conversation.dart';


part 'student.freezed.dart';
part 'student.g.dart';
@freezed
class Student with _$Student {
  const factory Student(
      int id,
      String? uid,
      User user,
      List<int> favorites,
      List<Schedule> learningHistory,
      List<Review> reviews,
      List<Conversation> conversations,
      ) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
