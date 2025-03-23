class TutorProfile {
  final List<String> subjects;
  final List<String> degrees;
  final int experienceYears;
  final int pricePerHour;
  final Location location;
  final double rating;
  final List<TutorReview> reviews;
  final List<Availability> availability;
  final String bio;
  final List<Certification> certifications;

  TutorProfile({
    required this.subjects,
    required this.degrees,
    required this.experienceYears,
    required this.pricePerHour,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.availability,
    required this.bio,
    required this.certifications,
  });

  factory TutorProfile.fromJson(Map<String, dynamic> json) {
    return TutorProfile(
      subjects: List<String>.from(json['subjects']),
      degrees: List<String>.from(json['degrees']),
      experienceYears: json['experience_years'],
      pricePerHour: json['price_per_hour'],
      location: Location.fromJson(json['location']),
      rating: json['rating'].toDouble(),
      reviews: (json['reviews'] as List)
          .map((e) => TutorReview.fromJson(e))
          .toList(),
      availability: (json['availability'] as List)
          .map((e) => Availability.fromJson(e))
          .toList(),
      bio: json['bio'],
      certifications: (json['certifications'] as List)
          .map((e) => Certification.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subjects': subjects,
      'degrees': degrees,
      'experience_years': experienceYears,
      'price_per_hour': pricePerHour,
      'location': location.toJson(),
      'rating': rating,
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'availability': availability.map((e) => e.toJson()).toList(),
      'bio': bio,
      'certifications': certifications.map((e) => e.toJson()).toList(),
    };
  }
}

class Location {
  final String city;
  final String district;

  Location({required this.city, required this.district});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      city: json['city'],
      district: json['district'],
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'district': district,
  };
}

class TutorReview {
  final String studentId;
  final int rating;
  final String comment;
  final DateTime date;

  TutorReview({
    required this.studentId,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory TutorReview.fromJson(Map<String, dynamic> json) {
    return TutorReview(
      studentId: json['student_id'],
      rating: json['rating'],
      comment: json['comment'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
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
      dayOfWeek: json['day_of_week'],
      timeSlots: List<String>.from(json['time_slots']),
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
      title: json['title'],
      fileUrl: json['file_url'],
      issuedAt: json['issued_at'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'file_url': fileUrl,
    'issued_at': issuedAt,
  };
}
