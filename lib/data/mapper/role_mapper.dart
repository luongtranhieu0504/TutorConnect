import '../../domain/model/role.dart';
import '../network/dto/role_dto.dart';

extension RoleDtoExtension on RoleDto {
  Role toModel() {
    return Role(
      id ?? 0,
      name ?? '',
      description,
      type
    );
  }
}