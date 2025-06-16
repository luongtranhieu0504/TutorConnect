

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/presentation/screens/tutor/tutor_home/tutor_home_state.dart';

import '../../../../common/async_state.dart';
import '../../../../common/stream_wrapper.dart';
import '../../../../domain/repository/tutor_repository.dart';

@injectable
class TutorHomeBloc extends Cubit<TutorHomeState> {
  final TutorRepository _tutorRepository;
  final updateBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);

  TutorHomeBloc(this._tutorRepository) : super(Initial());


  // Future<void> getTutorById(int id) async {
  //   emit(Loading());
  //   final result = await _tutorRepository.getTutorById(id);
  //   result.when(
  //     success: (tutor) {
  //       emit(Success(tutor!));
  //     },
  //     failure: (error) {
  //       emit(Failure(error.toString()));
  //     },
  //   );
  // }

  Future<void> updateTutor(int id, Map<String, dynamic> data) async {
    updateBroadcast.add(AsyncState.loading());
    final result = await _tutorRepository.updateTutor(id, data);
    result.when(
      success: (tutor) {
        updateBroadcast.add(AsyncState.success(true));
        emit(Success(tutor!));
      },
      failure: (error) {
        updateBroadcast.add(AsyncState.failure(error.toString()));
        emit(Failure(error.toString()));
      },
    );
  }

  Future<void> getCurrentTutor() async {
    emit(Loading());
    final result = await _tutorRepository.getCurrentTutor();
    result.when(
      success: (tutor) {
        emit(Success(tutor!));
      },
      failure: (error) {
        emit(Failure(error.toString()));
      },
    );
  }
}