import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/domain/model/review.dart';
import 'package:tutorconnect/domain/model/schedule.dart';
import 'package:tutorconnect/domain/model/schedule_slot.dart';
import 'package:tutorconnect/domain/model/user.dart';
import 'certification.dart';
import 'conversation.dart';


part 'tutor.freezed.dart';
part 'tutor.g.dart';
@freezed
class Tutor with _$Tutor {
  const factory Tutor(
      int id,
      String? uid,
      User user,
      List<Schedule> schedules,
      List<Review> reviews,
      List<Conversation> conversations,
      List<String> subjects,
      List<String> degrees,
      int? experienceYears,
      int? pricePerHour,
      List<ScheduleSlot> availability,
      String? bio,
      double? rating,
      List<Certification> certifications,
      ) = _Tutor;

  factory Tutor.fromJson(Map<String, dynamic> json) =>
      _$TutorFromJson(json);
}
