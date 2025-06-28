

import 'package:injectable/injectable.dart';

import '../network/api/tutor_api.dart';
import '../network/dto/response_dto.dart';
import '../network/dto/tutor_dto.dart';

@singleton
class TutorNetworkDataSource {
  final TutorApi _tutorApi;

  TutorNetworkDataSource(this._tutorApi);

  Future<ResponseDto<TutorDto>> getCurrentTutor() => _tutorApi.getCurrentTutor();

  Future<ResponseDto<List<TutorDto>>> getTutorList({String? subject}) =>
      _tutorApi.getTutors(subject: subject);

  Future<ResponseDto<TutorDto>> getTutorById(int id) => _tutorApi.getTutorById(id);

  Future<ResponseDto<TutorDto>> updateTutor(int id, Map<String, dynamic> data) => _tutorApi.updateTutor(id, data);

}