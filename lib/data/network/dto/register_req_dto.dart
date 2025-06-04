import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_req_dto.freezed.dart';
part 'register_req_dto.g.dart';

@freezed
class RegisterReqDto with _$RegisterReqDto {
  const factory RegisterReqDto(
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'password') String? password,
    @JsonKey(name: 'role') int? role,
  ) = _RegisterReqDto;

  factory RegisterReqDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterReqDtoFromJson(json);
}