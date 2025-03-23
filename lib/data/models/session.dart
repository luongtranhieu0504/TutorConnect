class SessionModel {
  final String id;
  final String studentId;
  final String tutorId;
  final String subject;
  final DateTime datetime;
  final int durationMinutes; // 60, 90, 120 phút
  final String location; // nếu offline
  final String status;
  final double tuition;
  final int? studentRating;
  final String? studentFeedback;

  SessionModel({
    required this.id,
    required this.studentId,
    required this.tutorId,
    required this.subject,
    required this.datetime,
    required this.durationMinutes,
    required this.location,
    required this.status,
    required this.tuition,
    this.studentRating,
    this.studentFeedback,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'],
      studentId: json['student_id'],
      tutorId: json['tutor_id'],
      subject: json['subject'],
      datetime: DateTime.parse(json['datetime']),
      durationMinutes: json['duration_minutes'],
      location: json['location'],
      status: json['status'],
      tuition: json['tuition'],
      studentRating: json['student_rating'],
      studentFeedback: json['student_feedback'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'student_id': studentId,
    'tutor_id': tutorId,
    'subject': subject,
    'datetime': datetime.toIso8601String(),
    'duration_minutes': durationMinutes,
    'location': location,
    'status': status,
    'tuition': tuition,
    'student_rating': studentRating,
    'student_feedback': studentFeedback,
  };
}
