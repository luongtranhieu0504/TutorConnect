import 'package:freezed_annotation/freezed_annotation.dart';
import 'student_dto.dart';
import 'tutor_dto.dart';

part 'review_dto.freezed.dart';
part 'review_dto.g.dart';

@freezed
class ReviewDto with _$ReviewDto {
  const factory ReviewDto({
    @JsonKey(name: 'id') int? id,

    @JsonKey(name: 'rating') int? rating,

    @JsonKey(name: 'comment') String? comment,

    @JsonKey(name: 'date') DateTime? date,

    @JsonKey(name: 'student') int? student,

    @JsonKey(name: 'tutor') int? tutor,

    @JsonKey(name: 'student_name') String? studentName,
  }) = _ReviewDto;

  factory ReviewDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewDtoFromJson(json);
}
