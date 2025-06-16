import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_message_dto.freezed.dart';
part 'send_message_dto.g.dart';

@freezed
class SendMessageDto with _$SendMessageDto {
  const factory SendMessageDto({
    @JsonKey(name: 'sender') required int sender,
    @JsonKey(name: 'receiver') required int receiver,
    @JsonKey(name: 'conversation') required int conversation,
    @JsonKey(name: 'content') required String content,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'timestamp') required DateTime timestamp,
    @JsonKey(name: 'isRead') required bool isRead,
    @JsonKey(name: 'imageUrl') String? imageUrl,
    @JsonKey(name: 'videoUrl') String? videoUrl,
    @JsonKey(name: 'fileUrl') String? fileUrl,
  }) = _SendMessageDto;

  factory SendMessageDto.fromJson(Map<String, dynamic> json) =>
      _$SendMessageDtoFromJson(json);
}

extension SendMessageDtoJsonConverter on SendMessageDto {
  Map<String, dynamic> toStrapiJson() {
    return {
      'data': toJson(),
    };
  }
}