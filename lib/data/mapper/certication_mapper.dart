
import '../../domain/model/certification.dart';
import '../network/dto/certification_dto.dart';

extension CertificationDtoExtension on CertificationDto {
  Certification toModel() {
    return Certification(
      title!,
      file,
      issuedAt!
    );
  }
}
