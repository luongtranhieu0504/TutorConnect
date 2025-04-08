import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorconnect/data/models/comment.dart';

final List<Comment> sampleComments = [
  // Comment on a student's question post
  Comment(
    id: 'CMT001',
    postId: 'POST001',
    authorId: 'TUT001',
    authorName: 'Nguyễn Văn A',
    authorPhotoUrl: 'https://example.com/avatars/tutorA.jpg',
    authorRole: 'gia sư',
    content: 'Em có thể giải bài này bằng cách sử dụng công thức rồi tích phân từng phần.',
    createdAt: DateTime(2024, 5, 15, 15, 45),
  ),

  // Another comment on the same post
  Comment(
    id: 'CMT002',
    postId: 'POST001',
    authorId: 'STU002',
    authorName: 'Trần Hà My',
    authorPhotoUrl: 'https://example.com/avatars/student2.jpg',
    authorRole: 'học sinh',
    content: 'Mình cũng đang gặp khó khăn với bài tập này. Cảm ơn thầy đã giải đáp!',
    createdAt: DateTime(2024, 5, 15, 16, 20),
  ),

  // Comment on a tutor offer post
  Comment(
    id: 'CMT003',
    postId: 'POST002',
    authorId: 'STU004',
    authorName: 'Lê Thanh Tùng',
    authorPhotoUrl: 'https://example.com/avatars/student4.jpg',
    authorRole: 'học sinh',
    content: 'Thầy có dạy online không ạ? Em đang ở Hà Nội.',
    createdAt: DateTime(2024, 5, 14, 10, 30),
  ),

  // Reply to a comment
  Comment(
    id: 'CMT004',
    postId: 'POST002',
    authorId: 'TUT001',
    authorName: 'Nguyễn Văn A',
    authorPhotoUrl: 'https://example.com/avatars/tutorA.jpg',
    authorRole: 'gia sư',
    content: '@Lê Thanh Tùng: Có em nhé, thầy cũng có lớp online vào tối thứ 3 và thứ 5 hàng tuần.',
    createdAt: DateTime(2024, 5, 14, 11, 15),
  ),

  // Comment on a discussion post
  Comment(
    id: 'CMT005',
    postId: 'POST003',
    authorId: 'TUT005',
    authorName: 'Phạm Thu Hà',
    authorPhotoUrl: 'https://example.com/avatars/tutorE.jpg',
    authorRole: 'gia sư',
    content: 'Mình gợi ý bạn nên dùng bộ sách Cambridge IELTS 17-19 mới nhất để luyện đề, kết hợp với IELTS Trainer của Cambridge để nắm phương pháp làm bài.',
    createdAt: DateTime(2024, 5, 13, 19, 30),
  ),

  // Comment on success story
  Comment(
    id: 'CMT006',
    postId: 'POST005',
    authorId: 'TUT001',
    authorName: 'Nguyễn Văn A',
    authorPhotoUrl: 'https://example.com/avatars/tutorA.jpg',
    authorRole: 'gia sư',
    content: 'Chúc mừng em nhé! Thành quả xứng đáng cho những nỗ lực của em trong suốt thời gian qua.',
    createdAt: DateTime(2024, 5, 12, 20, 15),
  ),

  // Comment asking a question
  Comment(
    id: 'CMT007',
    postId: 'POST004',
    authorId: 'STU010',
    authorName: 'Vũ Hoàng Anh',
    authorPhotoUrl: 'https://example.com/avatars/student10.jpg',
    authorRole: 'học sinh',
    content: 'Cô ơi, buổi học sẽ kéo dài bao lâu ạ? Em muốn đăng ký nhưng sợ trùng lịch với lớp học khác.',
    createdAt: DateTime(2024, 5, 16, 11, 45),
  ),

  // Response to a question
  Comment(
    id: 'CMT008',
    postId: 'POST004',
    authorId: 'TUT002',
    authorName: 'Trần Thị B',
    authorPhotoUrl: 'https://example.com/avatars/tutorB.jpg',
    authorRole: 'gia sư',
    content: 'Buổi học sẽ kéo dài khoảng 90 phút (từ 19:00-20:30) em nhé.',
    createdAt: DateTime(2024, 5, 16, 12, 10),
  ),
];