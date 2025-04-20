class TutorProfile {
  final List<String> subjects;
  final List<String> degrees;
  final int experienceYears;
  final int pricePerHour;
  final List<Availability> availability;
  final String bio;
  final double rating;
  final List<Certification> certifications;

  TutorProfile({
    required this.subjects,
    required this.degrees,
    required this.experienceYears,
    required this.pricePerHour,
    required this.availability,
    required this.bio,
    required this.rating,
    required this.certifications,
  });

  factory TutorProfile.fromJson(Map<String, dynamic> json) {
    return TutorProfile(
      subjects: (json['subjects'] as List?)?.map((e) => e.toString()).toList() ?? [],
      degrees: (json['degrees'] as List?)?.map((e) => e.toString()).toList() ?? [],
      experienceYears: (json['experienceYears'] is int)
          ? json['experienceYears']
          : int.tryParse(json['experienceYears']?.toString() ?? '0') ?? 0,
      pricePerHour: (json['pricePerHour'] is int)
          ? json['pricePerHour']
          : int.tryParse(json['pricePerHour']?.toString() ?? '0') ?? 0,
      rating: (json['rating'] is double)
          ? json['rating']
          : double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      availability: (json['availability'] as List?)
          ?.whereType<Map<String, dynamic>>()
          .map((e) => Availability.fromJson(e))
          .toList() ??
          [],
      bio: json['bio'] as String? ?? '',
      certifications: (json['certifications'] as List?)
          ?.whereType<Map<String, dynamic>>()
          .map((e) => Certification.fromJson(e))
          .toList() ??
          [],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'subjects': subjects,
      'degrees': degrees,
      'experience_years': experienceYears,
      'price_per_hour': pricePerHour,
      'availability': availability.map((e) => e.toJson()).toList(),
      'bio': bio,
      'rating': rating,
      'certifications': certifications.map((e) => e.toJson()).toList(),
    };
  }
}

class TutorReview {
  final String studentId;
  final String studentName;
  final int rating;
  final String comment;
  final DateTime date;

  TutorReview({
    required this.studentId,
    required this.studentName,
    required this.rating,
    required this.comment,
    required this.date,
  });


  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
}

class Availability {
  final String dayOfWeek;
  final List<String> timeSlots;

  Availability({required this.dayOfWeek, required this.timeSlots});

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      dayOfWeek: json['day_of_week'] as String? ?? '',
      timeSlots: (json['time_slots'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'day_of_week': dayOfWeek,
    'time_slots': timeSlots,
  };
}

class Certification {
  final String title;
  final String fileUrl;
  final String issuedAt;

  Certification({
    required this.title,
    required this.fileUrl,
    required this.issuedAt,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      title: json['title'] as String? ?? '',
      fileUrl: json['file_url'] as String? ?? '',
      issuedAt: json['issued_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'file_url': fileUrl,
    'issued_at': issuedAt,
  };
}
