

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/domain/repository/tutor_repository.dart';

import '../../../../common/async_state.dart';
import '../../../../common/stream_wrapper.dart';
import '../../../../data/manager/account.dart';
import '../../../../domain/model/tutor.dart';
import 'favorite_state.dart';

@injectable
class FavoriteBloc extends Cubit<FavoriteState> {
  final TutorRepository _tutorRepository;
  final removeBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);
  final student = Account.instance.student;
  final List<Tutor> favoriteTutors = [];

  FavoriteBloc(this._tutorRepository) : super(Initial());

  Future<void> getFavorites() async {
    emit(Loading());
    for (final tutorId in student!.favorites) {
      final result = await _tutorRepository.getTutorById(tutorId);
      if (result.isSuccess) {
        final tutor = result.data;
        if (tutor != null) {
          favoriteTutors.add(tutor);
        }
      }
    }
    if (favoriteTutors.isEmpty) {
      emit(Failure("No favorite tutors found"));
    } else {
      emit(Success(favoriteTutors));
    }
  }



  Future<void> removeFavorite(int tutorId) async {
    if (!student!.favorites.contains(tutorId)) {
      removeBroadcast.add(AsyncState.failure("Tutor not in favorites"));
      return;
    }
    student!.favorites.remove(tutorId);
    final result = await _tutorRepository.updateTutor(student!.id, {'favorites': student!.favorites});
    result.when(
        success: (success) {
          removeBroadcast.add(AsyncState.success(true));
          favoriteTutors.removeWhere((tutor) => tutor.id == tutorId);
        },
        failure: (failure) {
          removeBroadcast.add(AsyncState.failure(failure));
        }
    );

  }

}