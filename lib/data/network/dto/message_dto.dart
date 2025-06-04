import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/data/network/dto/user_dto.dart';
import 'conversation_dto.dart';
import 'conversation_dto.dart';
import 'schedule_dto.dart';

part 'message_dto.freezed.dart';
part 'message_dto.g.dart';

@freezed
class MessageDto with _$MessageDto {
  const factory MessageDto({
    @JsonKey(name: 'id') int? id,

    @JsonKey(name: 'sender') UserDto? sender,
    @JsonKey(name: 'receiver') UserDto? receiver,
    @JsonKey(name: 'conversation') ConversationDto? conversation,

    @JsonKey(name: 'content') String? content,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'timestamp') DateTime? timestamp,
    @JsonKey(name: 'isRead') bool? isRead,

    @JsonKey(name: 'imageUrl') String? imageUrl,
    @JsonKey(name: 'videoUrl') String? videoUrl,
    @JsonKey(name: 'fileUrl') String? fileUrl,
    @JsonKey(name: 'reactions') Map<String, dynamic>? reactions,

    @JsonKey(name: 'schedule') ScheduleDto? schedule,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}
