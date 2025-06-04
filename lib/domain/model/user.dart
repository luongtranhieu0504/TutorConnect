import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/domain/model/post.dart';
import 'package:tutorconnect/domain/model/role.dart';
import 'package:tutorconnect/domain/model/student.dart';
import 'package:tutorconnect/domain/model/tutor.dart';
import 'comment.dart';
import 'conversation.dart';
import 'message.dart';


part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User(
      int id,
      String? username,
      String? email,
      Role? role,
      String? name,
      String? school,
      String? grade,
      String? phone,
      String? photoUrl,
      dynamic bio,
      String? address,
      String? state,
      String? typeRole,
      Student? student,
      Tutor? tutor,
      List<Message> sentMessages,
      List<Message> receivedMessages,
      List<Post> posts,
      List<Comment> comments,
      ) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
