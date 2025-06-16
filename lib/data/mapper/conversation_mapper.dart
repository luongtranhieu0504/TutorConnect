import 'package:tutorconnect/data/mapper/message_mapper.dart';
import 'package:tutorconnect/data/mapper/orher_user_mapper.dart';
import 'package:tutorconnect/data/mapper/student_mapper.dart';
import 'package:tutorconnect/data/mapper/tutor_mapper.dart';

import '../../domain/model/conversation.dart';
import '../network/dto/conversation_dto.dart';

extension ConversationDtoExtension on ConversationDto {
  Conversation toModel() {
    return Conversation(
      id ?? 0,
      lastMessage,
      lastTimestamp,
      student ?? 0,
      tutor ?? 0,
      messages?.map((e) => e.toModel()).toList() ?? [],
      otherUser?.toModel(),
    );
  }
}
