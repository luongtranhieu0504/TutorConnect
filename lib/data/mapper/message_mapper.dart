import 'package:tutorconnect/data/mapper/conversation_mapper.dart';
import 'package:tutorconnect/data/mapper/schedule_mapper.dart';
import 'package:tutorconnect/data/mapper/user_mapper.dart';
import '../../domain/model/message.dart';
import '../network/dto/message_dto.dart';

extension MessageDtoExtension on MessageDto {
  Message toModel() {
    return Message(
      id ?? 0,
      sender?.toModel(),
      receiver?.toModel(),
      conversation?.toModel(),
      content,
      type,
      timestamp,
      isRead,

      imageUrl,
      videoUrl,
      fileUrl,
      reactions,

      schedule?.toModel(),
    );
  }
}
