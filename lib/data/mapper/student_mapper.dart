import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutorconnect/data/mapper/conversation_mapper.dart';
import 'package:tutorconnect/data/mapper/review_mapper.dart';
import 'package:tutorconnect/data/mapper/schedule_mapper.dart';
import 'package:tutorconnect/data/mapper/tutor_mapper.dart';
import 'package:tutorconnect/data/mapper/user_mapper.dart';

import '../../domain/model/student.dart';
import '../network/dto/student_dto.dart';

extension StudentDtoExtension on StudentDto {
  Student toModel() {
    return Student(
      id ?? 0,
      user!.toModel(),
      favorites?.map((favorite) => favorite['id'] as int).toList() ?? [],
      learningHistory?.map((e) => e.toModel()).toList() ?? [],
      reviews?.map((e) => e.toModel()).toList() ?? [],
      conversations?.map((e) => e.toModel()).toList() ?? [],
    );
  }
}
