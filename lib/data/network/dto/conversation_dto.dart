import 'package:freezed_annotation/freezed_annotation.dart';
import 'message_dto.dart';

part 'conversation_dto.freezed.dart';
part 'conversation_dto.g.dart';

@freezed
class ConversationDto with _$ConversationDto {
  const factory ConversationDto({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'lastMessage') String? lastMessage,
    @JsonKey(name: 'lastTimestamp') DateTime? lastTimestamp,
    @JsonKey(name: 'student') int? student,
    @JsonKey(name: 'tutor') int? tutor,
    @JsonKey(name: 'messages') List<MessageDto>? messages,
  }) = _ConversationDto;

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);
}
