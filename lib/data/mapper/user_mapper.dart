import 'package:tutorconnect/data/mapper/comment_mapper.dart';
import 'package:tutorconnect/data/mapper/message_mapper.dart';
import 'package:tutorconnect/data/mapper/post_mapper.dart';
import 'package:tutorconnect/data/mapper/role_mapper.dart';
import 'package:tutorconnect/data/mapper/student_mapper.dart';
import 'package:tutorconnect/data/mapper/tutor_mapper.dart';
import '../../domain/model/user.dart';
import '../network/dto/user_dto.dart';

extension UserDtoExtension on UserDto {
  User toModel() {
    return User(
      id ?? 0,
      username,
      email,
      role?.toModel(),
      name,
      school,
      grade,
      phone,
      photoUrl,
      bio,
      address,
      state,
      typeRole,
      student?.toModel(),
      tutor?.toModel(),
      sentMessages?.map((e) => e.toModel()).toList() ?? [],
      receivedMessages?.map((e) => e.toModel()).toList() ?? [],
      posts?.map((e) => e.toModel()).toList() ?? [],
      comments?.map((e) => e.toModel()).toList() ?? [],
    );
  }
}
