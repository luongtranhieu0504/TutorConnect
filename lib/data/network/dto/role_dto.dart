import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_dto.freezed.dart';
part 'role_dto.g.dart';

@freezed
class RoleDto with _$RoleDto {
  const factory RoleDto({
    required int id,
    required String name,
    String? description,
    String? type,
  }) = _RoleDto;

  factory RoleDto.fromJson(Map<String, dynamic> json) => _$RoleDtoFromJson(json);
}