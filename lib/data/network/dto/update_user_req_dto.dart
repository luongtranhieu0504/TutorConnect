import 'package:freezed_annotation/freezed_annotation.dart';


part 'update_user_req_dto.freezed.dart';
part 'update_user_req_dto.g.dart';

@freezed
class UpdateUserReqDto with _$UpdateUserReqDto {
  const factory UpdateUserReqDto({
    @JsonKey(name: 'fcmToken') String? fcmToken,
    @JsonKey(name: 'photoUrl') String? photoUrl,
    @JsonKey(name: 'phone') String? phoneNumber,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'school') String? school,
    @JsonKey(name: 'grade') String? grade,
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'state') String? state,
    @JsonKey(name: 'bio') String? bio,
  }) = _UpdateUserReqDto;

  factory UpdateUserReqDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserReqDtoFromJson(json);
}
