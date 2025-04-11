import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/models/users.dart';
import '../../../common/async_state.dart';
import '../../../common/stream_wrapper.dart';
import '../../../domain/repository/auth/login_repository.dart';

@injectable
class LoginBloc {
  late final LoginRepository _loginRepository;
  final signInBroadcast = StreamWrapper<AsyncState<UserModel>>(broadcast: true);
  final resetPasswordBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);
  final updateBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);
  final registerBroadcast = StreamWrapper<AsyncState<String>>(broadcast: true);
  final logoutBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);

  LoginBloc(this._loginRepository);

  void signIn(String email, String password) async {
    signInBroadcast.add(const AsyncState.loading());
    final result = await _loginRepository.signInWithEmail(email, password);
    result.when(
      success: (user) {
        signInBroadcast.add(AsyncState.success(user));
      },
      failure: (message) {
        signInBroadcast.add(AsyncState.failure(message));
      },
    );
  }

  void resetPassword(String email) async {
    resetPasswordBroadcast.add(const AsyncState.loading());
    final result = await _loginRepository.resetPassword(email);
    result.when(
      success: (role) {
        resetPasswordBroadcast.add(AsyncState.success(true));
      },
      failure: (message) {
        resetPasswordBroadcast.add(AsyncState.failure(message));
      },
    );
  }

  void signUp(String email, String password, String? role) async {
    registerBroadcast.add(const AsyncState.loading());
    final result = await _loginRepository.signUpWithEmail(
        email: email, password: password, role: role);
    result.when(
      success: (user) {
        registerBroadcast.add(AsyncState.success(user));
      },
      failure: (message) {
        registerBroadcast.add(AsyncState.failure(message));
      },
    );
  }

  void updateUser(String uid, Map<String, dynamic> data) async {
    updateBroadcast.add(const AsyncState.loading());
    final result = await _loginRepository.updateUser(uid, data);
    result.when(
      success: (user) {
        updateBroadcast.add(AsyncState.success(true));
      },
      failure: (message) {
        updateBroadcast.add(AsyncState.failure(message));
      },
    );
  }

  void logout() async {
    logoutBroadcast.add(const AsyncState.loading());
    final result = await _loginRepository.logout();
    result.when(
        success: (user) {
          logoutBroadcast.add(AsyncState.success(true));
        },
        failure: (message) {
          logoutBroadcast.add(AsyncState.failure(message));
        }
    );
  }

  void dispose() {
    signInBroadcast.close();
    registerBroadcast.close();
    logoutBroadcast.close();
  }
}
