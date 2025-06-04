import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/domain/model/student.dart';
import 'package:tutorconnect/domain/model/tutor.dart';


part 'review.freezed.dart';
part 'review.g.dart';
@freezed
class Review with _$Review {
  const factory Review(
      int id,
      int? rating,
      String? comment,
      DateTime? date,
      int? student,
      int? tutor,
      String? studentName,
      ) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}
