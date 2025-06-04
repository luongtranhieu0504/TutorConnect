import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutorconnect/data/network/dto/user_dto.dart';

part 'login_res_dto.freezed.dart';
part 'login_res_dto.g.dart';

@freezed
class LoginResDto with _$LoginResDto {
  const factory LoginResDto({
    @JsonKey(name: 'jwt') String? token,
    @JsonKey(name: 'user') UserDto? user,
  }) = _LoginResDto;

  factory LoginResDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResDtoFromJson(json);
}