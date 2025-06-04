

import 'package:injectable/injectable.dart';

import '../network/api/tutor_api.dart';
import '../network/dto/response_dto.dart';
import '../network/dto/tutor_dto.dart';

@singleton
class TutorNetworkDataSource {
  final TutorApi _tutorApi;

  TutorNetworkDataSource(this._tutorApi);

  Future<ResponseDto<TutorDto>> getCurrentTutor() => _tutorApi.getCurrentTutor();

  Future<ResponseDto<List<TutorDto>>> getTutorsList() => _tutorApi.getTutorsList();

  Future<ResponseDto<TutorDto>> updateTutor(int id, Map<String, dynamic> data) => _tutorApi.updateTutor(id, data);
}