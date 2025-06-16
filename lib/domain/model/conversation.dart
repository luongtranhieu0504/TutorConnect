import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/domain/model/student.dart';
import 'package:tutorconnect/domain/model/tutor.dart';
import 'message.dart';
import 'other_user.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation(
      int id,
      String? lastMessage,
      DateTime? lastTimestamp,
      int student,
      int tutor,
      List<Message> messages,
      OtherUser? otherUser,
      ) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}

