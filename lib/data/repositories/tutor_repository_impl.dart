

import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/mapper/tutor_mapper.dart';

import '../../common/task_result.dart';
import '../../domain/model/tutor.dart';
import '../../domain/repository/tutor_repository.dart';
import '../manager/account.dart';
import '../network/api_call.dart';
import '../network/dto/tutor_dto.dart';
import '../source/tutor_network_data_source.dart';

@Singleton(as:  TutorRepository)
class TutorRepositoryImpl implements TutorRepository {
  final TutorNetworkDataSource _dataSource;

  TutorRepositoryImpl(this._dataSource);

  @override
  Future<TaskResult<Tutor?>> updateTutor(int id, Map<String, dynamic> data) =>
      callApi(() async {
        final response = await _dataSource.updateTutor(id, data);
        final tutor = response.data!.toModel();

        if(Account.instance.tutor?.id == id) {
          // Update cache if needed
          Account.instance.saveTutor(tutor);
        }
        return tutor;
      });

  @override
  Future<TaskResult<Tutor?>> getCurrentTutor() =>
      callApi(() async {
        if (Account.instance.tutor != null) {
          return Account.instance.tutor;
        }

        // Otherwise fetch from network
        final response = await _dataSource.getCurrentTutor();
        final tutor = response.data!.toModel();

        // Cache the student data
        Account.instance.saveTutor(tutor);

        return tutor;
      });

  @override
  Future<TaskResult<Tutor?>> getTutorById(int id) => callApi(() async {
    final response = await _dataSource.getTutorById(id);
    return response.data?.toModel();
  });

  @override
  Future<TaskResult<List<Tutor>>> getTutors({
    String? subject,
    bool topRated = false,
  }) =>
      callApi(() async {
        final response = await _dataSource.getTutorList(subject: subject);

        List<TutorDto> filteredTutors = response.data ?? [];

        if (topRated) {
          // Filter top-rated tutors with rating >= 4.5 and limit to 5
          filteredTutors = filteredTutors
              .where((tutor) => tutor.rating != null && tutor.rating! >= 4.5)
              .toList()
              .toList();
        }

        return filteredTutors.map((dto) => dto.toModel()).toList();
      });




}