
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/domain/repository/auth_repository.dart';
import 'package:tutorconnect/presentation/screens/profile/profile_state.dart';
import '../../../../common/async_state.dart';
import '../../../../common/stream_wrapper.dart';


@injectable
class ProfileBloc extends Cubit<ProfileState> {

  final AuthRepository _authRepository;

  final logOutBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);
  ProfileBloc(this._authRepository) : super(ProfileInitial());

  void logOut() async {
    emit(ProfileLoading());
    final result = await _authRepository.logout();
    result.when(
      success: (_) {
        logOutBroadcast.add(AsyncState.success(true));
        emit(ProfileInitial());
      },
      failure: (message) {
        logOutBroadcast.add(AsyncState.failure(message));
        emit(ProfileFailure(message));
      },
    );
  }


}
