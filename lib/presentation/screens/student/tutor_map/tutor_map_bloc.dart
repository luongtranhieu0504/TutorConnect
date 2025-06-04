
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/presentation/screens/student/tutor_map/tutor_map_state.dart';

import '../../../../domain/repository/student_home_repository.dart';
import '../../../../domain/repository/tutor_repository.dart';

@injectable
class TutorMapBloc extends Cubit<TutorMapState> {

  final TutorRepository _tutorRepository;

  TutorMapBloc(this._tutorRepository) : super(TutorMapInitial());

  void getTutors() async {
    emit(TutorMapLoading());
    final result = await _tutorRepository.getTutorsList();
    result.when(
      success: (tutors) => emit(TutorMapSuccess(tutors)),
      failure: (message) => emit(TutorMapFailure(message)),
    );
  }


}