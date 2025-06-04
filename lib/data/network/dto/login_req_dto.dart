import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_req_dto.freezed.dart';
part 'login_req_dto.g.dart';

@freezed
class LoginReqDto with _$LoginReqDto {
  const factory LoginReqDto(
    @JsonKey(name: 'identifier') String? identifier,
    @JsonKey(name: 'password') String? password,
  ) = _LoginReqDto;

  factory LoginReqDto.fromJson(Map<String, dynamic> json) =>
      _$LoginReqDtoFromJson(json);
}