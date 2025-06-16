import 'package:freezed_annotation/freezed_annotation.dart';

part 'other_user_dto.freezed.dart';
part 'other_user_dto.g.dart';

@freezed
class OtherUserDto with _$OtherUserDto {
  const factory OtherUserDto({
    required int id,
    String? name,
    String? email,
    String? photoUrl,
    String? address,
  }) = _OtherUserDto;

  factory OtherUserDto.fromJson(Map<String, dynamic> json) =>
      _$OtherUserDtoFromJson(json);
}