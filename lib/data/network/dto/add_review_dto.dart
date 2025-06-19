import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_review_dto.freezed.dart';
part 'add_review_dto.g.dart';

@freezed
class AddReviewDto with _$AddReviewDto {
  const factory AddReviewDto({
    @JsonKey(name: 'rating') required int rating,
    @JsonKey(name: 'comment') String? comment,
    @JsonKey(name: 'date') required DateTime date,
    @JsonKey(name: 'student_name') required String studentName,
    @JsonKey(name: 'student') required int student,
    @JsonKey(name: 'tutor') required int tutor,
  }) = _AddReviewDto;

  factory AddReviewDto.fromJson(Map<String, dynamic> json) =>
      _$AddReviewDtoFromJson(json);
}

extension AddReviewDtoJsonConverter on AddReviewDto {
  Map<String, dynamic> toStrapiJson() {
    return {
      'data': toJson(),
    };
  }
}