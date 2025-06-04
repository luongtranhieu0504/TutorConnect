import 'package:tutorconnect/data/mapper/student_mapper.dart';
import 'package:tutorconnect/data/mapper/tutor_mapper.dart';

import '../../domain/model/review.dart';
import '../network/dto/review_dto.dart';

extension ReviewDtoExtension on ReviewDto {
  Review toModel() {
    return Review(
      id ?? 0,
      rating ?? 0,
      comment,
      date,
      student,
      tutor,
      studentName,
    );
  }
}
