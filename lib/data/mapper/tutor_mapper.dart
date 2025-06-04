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

// Add this extension to your tutor_dto.dart file
extension TutorDtoMapper on TutorDto {
  Tutor toModel() {
    // Safely convert reviews
    final List<Review> reviewModels = reviews?.map((reviewDto) {
      // If the reviewDto doesn't have complete data, create a minimal review
      return Review(
        reviewDto.id ?? 0,
        reviewDto.rating ?? 0,
        reviewDto.comment ?? '',
        reviewDto.date ?? DateTime.now(),
        null, // student can be null if not provided
        null, // tutor can be null if not provided
        reviewDto.studentName ?? '',
      );
    }).toList() ?? [];

    return Tutor(
      id ?? 0,
      uid,
      user!.toModel(), // Provide default User
      schedules?.map((s) => s.toModel()).toList() ?? [],
      reviewModels, // Use our safely converted reviews
      conversations?.map((c) => c.toModel()).toList() ?? [],
      subjects ?? [],
      degrees ?? [],
      experienceYears,
      pricePerHour,
      availability?.map((a) => a.toModel()).toList() ?? [],
      bio,
      rating,
      certifications?.map((c) => c.toModel()).toList() ?? [],
    );
  }
}
