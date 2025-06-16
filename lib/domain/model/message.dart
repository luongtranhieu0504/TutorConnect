import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/domain/model/schedule.dart';
import 'package:tutorconnect/domain/model/user.dart';
import 'conversation.dart';


part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message(
      int id,
      User? sender,
      User? receiver,
      Conversation? conversation,

      String? content,
      String? type,
      DateTime? timestamp,
      bool? isRead,

      String? imageUrl,
      String? videoUrl,
      String? fileUrl,
      Map<String, dynamic>? reactions,

      Schedule? schedule,
      ) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
