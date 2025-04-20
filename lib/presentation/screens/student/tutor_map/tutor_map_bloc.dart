
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/domain/repository/tutor_map_repository.dart';
import 'package:tutorconnect/presentation/screens/student/tutor_map/tutor_map_state.dart';

import '../../../../domain/repository/student_home_repository.dart';

@injectable
class TutorMapBloc extends Cubit<TutorMapState> {

  final TutorMapRepository _tutorMapRepository;

  TutorMapBloc(this._tutorMapRepository) : super(TutorMapInitial());

  void getTutors() async {
    emit(TutorMapLoading());
    final result = await _tutorMapRepository.getTutors();
    result.when(
      success: (tutors) => emit(TutorMapSuccess(tutors)),
      failure: (message) => emit(TutorMapFailure(message)),
    );
  }



}