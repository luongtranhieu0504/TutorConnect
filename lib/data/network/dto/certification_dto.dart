import 'package:freezed_annotation/freezed_annotation.dart';

part 'certification_dto.freezed.dart';
part 'certification_dto.g.dart';

@freezed
class CertificationDto with _$CertificationDto {
  const factory CertificationDto({
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'file') String? file,
    @JsonKey(name: 'issuedAt') DateTime? issuedAt,
  }) = _CertificationDto;

  factory CertificationDto.fromJson(Map<String, dynamic> json) =>
      _$CertificationDtoFromJson(json);
}
