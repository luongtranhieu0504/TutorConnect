import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_dto.freezed.dart';
part 'response_dto.g.dart';

@Freezed(
  genericArgumentFactories: true,
)
class ResponseDto<T> with _$ResponseDto<T> {
  const factory ResponseDto(
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'data') T? data,
      @JsonKey(name: 'message') String? message,
      ) = _ResponseDto<T>;

  factory ResponseDto.fromJson(
      Map<String, dynamic> json,
      T Function(Object?) fromJsonT,
      ) =>
      _$ResponseDtoFromJson(json, fromJsonT);
}
