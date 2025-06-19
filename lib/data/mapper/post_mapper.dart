import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutorconnect/data/mapper/comment_mapper.dart';
import 'package:tutorconnect/data/mapper/user_mapper.dart';
import '../../domain/model/post.dart';
import '../network/dto/post_dto.dart';

extension PostDtoExtension on PostDto {
  Post toModel() {
    return Post(
      id ?? 0,
      content,
      imageUrls?.map((e) => e).toList() ?? [],
      author!.toModel(),
      likedBy?.map((e) => e.toModel()).toList() ?? [],
      likeCount ?? 0,
      commentCount ?? 0,
      createdAt ?? DateTime.now(),
      comments?.map((e) => e.toModel()).toList() ?? [],
    );
  }
}
