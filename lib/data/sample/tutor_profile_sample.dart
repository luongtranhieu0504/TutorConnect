import '../models/tutor.dart';
import '../models/users.dart';

final List<UserModel> sampleTutorUsers = [
  UserModel(
    uid: 'TUT001',
    email: 'nguyenvanA@gmail.com',
    role: 'tutor',
    name: 'Nguyễn Văn A',
    school: 'Đại học Sư phạm TP.HCM',
    phone: '0901234567',
    photoUrl: 'https://example.com/avatars/tutorA.jpg',
    bio: 'Giáo viên nhiệt tình, có 5 năm kinh nghiệm giảng dạy',
    address: '123 Lê Lợi, Quận 1, TP.HCM',
    tutorProfile: TutorProfile(
      subjects: ['Toán', 'Vật Lý', 'Hóa Học'],
      degrees: ['Cử nhân Sư phạm Toán', 'Thạc sĩ Giáo dục'],
      experienceYears: 5,
      pricePerHour: 300000,
      rating: 4.9,
      reviews: [
        TutorReview(
          studentId: 'STU001',
          rating: 5,
          comment: 'Thầy dạy rất tận tâm và dễ hiểu',
          date: DateTime(2024, 3, 10),
        ),
      ],
      availability: [
        Availability(
          dayOfWeek: 'Thứ Hai',
          timeSlots: ['08:00-10:00', '14:00-16:00'],
        ),
      ],
      bio: 'Chuyên dạy khối Tự nhiên cho học sinh THPT',
      certifications: [
        Certification(
          title: 'Chứng chỉ Sư phạm Xuất sắc',
          fileUrl: 'https://example.com/certs/cert1.pdf',
          issuedAt: '2022-05-15',
        ),
      ],
    ),
  ),
  UserModel(
    uid: 'TUT002',
    email: 'tranthiB@gmail.com',
    role: 'tutor',
    name: 'Trần Thị B',
    school: 'Đại học Ngoại ngữ TP.HCM',
    phone: '0909876543',
    photoUrl: 'https://example.com/avatars/tutorB.jpg',
    bio: 'Giáo viên tiếng Anh với chứng chỉ IELTS 8.0',
    address: '456 Nguyễn Huệ, Quận 3, TP.HCM',
    tutorProfile: TutorProfile(
      subjects: ['Tiếng Anh', 'IELTS', 'TOEIC'],
      degrees: ['Cử nhân Ngôn ngữ Anh'],
      experienceYears: 3,
      pricePerHour: 250000,
      rating: 4.7,
      reviews: [
        TutorReview(
          studentId: 'STU002',
          rating: 5,
          comment: 'Cô giáo nhiệt tình, phương pháp dạy hiệu quả',
          date: DateTime(2024, 3, 5),
        ),
      ],
      availability: [
        Availability(
          dayOfWeek: 'Thứ Tư',
          timeSlots: ['15:00-17:00', '18:00-20:00'],
        ),
      ],
      bio: 'Chuyên luyện thi IELTS và tiếng Anh giao tiếp',
      certifications: [
        Certification(
          title: 'Chứng chỉ IELTS 8.0',
          fileUrl: 'https://example.com/certs/cert2.pdf',
          issuedAt: '2023-08-20',
        ),
      ],
    ),
  ),
];