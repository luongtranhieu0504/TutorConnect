import 'package:tutorconnect/data/models/post.dart';

final List<Post> samplePosts = [
  // Student Question Post
  Post(
    id: 'POST001',
    authorId: 'STU001',
    authorName: 'Lê Minh',
    authorPhotoUrl: 'https://example.com/avatars/student1.jpg',
    authorRole: 'học sinh',
    content: 'Mình đang gặp khó khăn với bài toán tích phân. Ai có thể giải thích cách giải bài tập này không? ',
    imageUrls: ['https://example.com/posts/math_problem1.jpg'],
    createdAt: DateTime(2024, 5, 15, 14, 30),
    likeCount: 5,
    commentCount: 3,
    likedBy: ['TUT001', 'STU002', 'STU003', 'STU005', 'TUT003'],
  ),

  // Tutor Offer Post
  Post(
    id: 'POST002',
    authorId: 'TUT001',
    authorName: 'Nguyễn Văn A',
    authorPhotoUrl: 'https://example.com/avatars/tutorA.jpg',
    authorRole: 'gia sư',
    content: 'Mình đang nhận dạy kèm Toán và Lý cho học sinh lớp 11-12 tại khu vực Quận 1 và Quận 3. Có 5 năm kinh nghiệm và chuyên luyện thi đại học. Học phí: 300k/giờ. Liên hệ: 0901234567',
    imageUrls: ['https://example.com/posts/tutor_profile1.jpg'],
    createdAt: DateTime(2024, 5, 14, 9, 15),
    likeCount: 12,
    commentCount: 7,
    likedBy: ['STU001', 'STU004', 'STU006', 'STU008', 'STU010', 'TUT004', 'TUT005'],
  ),

  // Student Discussion Post
  Post(
    id: 'POST003',
    authorId: 'STU002',
    authorName: 'Trần Hà My',
    authorPhotoUrl: 'https://example.com/avatars/student2.jpg',
    authorRole: 'học sinh',
    content: 'Mọi người có ai biết tài liệu luyện thi IELTS nào hiệu quả không? Mình đang chuẩn bị cho kỳ thi tháng sau.',
    imageUrls: [],
    createdAt: DateTime(2024, 5, 13, 18, 45),
    likeCount: 8,
    commentCount: 15,
    likedBy: ['TUT002', 'STU004', 'STU007', 'STU009'],
  ),

  // Tutor Announcement Post
  Post(
    id: 'POST004',
    authorId: 'TUT002',
    authorName: 'Trần Thị B',
    authorPhotoUrl: 'https://example.com/avatars/tutorB.jpg',
    authorRole: 'gia sư',
    content: 'Mình sẽ tổ chức lớp học nhóm MIỄN PHÍ về kỹ năng Speaking IELTS vào Chủ Nhật tuần này (19/5). Các bạn quan tâm có thể đăng ký qua link dưới đây.',
    imageUrls: ['https://example.com/posts/ielts_class.jpg'],
    createdAt: DateTime(2024, 5, 16, 10, 20),
    likeCount: 25,
    commentCount: 18,
    likedBy: ['STU002', 'STU003', 'STU005', 'STU007', 'STU008', 'STU010', 'STU011'],
  ),

  // Student Success Story Post
  Post(
    id: 'POST005',
    authorId: 'STU005',
    authorName: 'Nguyễn Hoàng Phúc',
    authorPhotoUrl: 'https://example.com/avatars/student5.jpg',
    authorRole: 'học sinh',
    content: 'Vừa nhận kết quả thi đại học với 27.5 điểm khối A! Cảm ơn thầy Nguyễn Văn A đã hỗ trợ mình trong suốt thời gian qua. Các bạn nào cần gia sư giỏi thì liên hệ thầy nhé!',
    imageUrls: ['https://example.com/posts/exam_result.jpg'],
    createdAt: DateTime(2024, 5, 12, 19, 30),
    likeCount: 45,
    commentCount: 22,
    likedBy: ['TUT001', 'TUT003', 'TUT004', 'STU001', 'STU002', 'STU003', 'STU006', 'STU008'],
  ),
];