import 'package:tutorconnect/data/mapper/post_mapper.dart';
import 'package:tutorconnect/data/mapper/user_mapper.dart';
import '../../domain/model/comment.dart';
import '../network/dto/comment_dto.dart';

extension CommentDtoExtension on CommentDto {
  Comment toModel() {
    return Comment(
      id ?? 0,
      content,
      imageUrls?.map((e) => e).toList() ?? [],
      author!.toModel(),
      null,
      createdAt ?? DateTime.now(),
    );
  }
}

