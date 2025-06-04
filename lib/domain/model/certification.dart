import 'package:freezed_annotation/freezed_annotation.dart';



part 'certification.freezed.dart';
part 'certification.g.dart';

@freezed
class Certification with _$Certification {
  const factory Certification(
    String? title,
    String? file,
    DateTime issuedAt,
  ) = _Certification;

  factory Certification.fromJson(Map<String, dynamic> json) =>
      _$CertificationFromJson(json);
}