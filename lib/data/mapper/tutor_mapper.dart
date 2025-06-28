import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutorconnect/data/mapper/certication_mapper.dart';
import 'package:tutorconnect/data/mapper/conversation_mapper.dart';
import 'package:tutorconnect/data/mapper/review_mapper.dart';
import 'package:tutorconnect/data/mapper/schedule_mapper.dart';
import 'package:tutorconnect/data/mapper/schedule_slot_mapper.dart';
import 'package:tutorconnect/data/mapper/user_mapper.dart';

import '../../domain/model/review.dart';
import '../../domain/model/tutor.dart';
import '../network/dto/tutor_dto.dart';

extension TutorDtoMapper on TutorDto {
  Tutor toModel() {
    return Tutor(
      id ?? 0,
      user!.toModel(),
      schedules?.map((e) => e.toModel()).toList() ?? [],
      reviews?.map((e) => e.toModel()).toList() ?? [],
      conversations?.map((e) => e.toModel()).toList() ?? [],
      subjects?.cast<String>() ?? [],
      experienceYears,
      pricePerHour,
      availability?.map((e) => e.toModel()).toList() ?? [],
      bio,
      rating,
      certifications?.map((e) => e.toModel()).toList() ?? [],
    );
  }
}
