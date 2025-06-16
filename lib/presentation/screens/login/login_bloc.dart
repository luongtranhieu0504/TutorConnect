import 'dart:io';

import 'package:injectable/injectable.dart';
import '../../../common/async_state.dart';
import '../../../common/stream_wrapper.dart';
import '../../../domain/repository/auth_repository.dart';

@injectable
class LoginBloc {
  late final AuthRepository _authRepository;
  final signInBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);
  // final resetPasswordBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);
  final updateBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);
  final registerBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);
  // final logoutBroadcast = StreamWrapper<AsyncState<bool>>(broadcast: true);

  LoginBloc(this._authRepository);

  void signIn(String identifier, String password) async {
    signInBroadcast.add(const AsyncState.loading());
    final result = await _authRepository.signIn(identifier, password);
    result.when(
      success: (data) {
        signInBroadcast.add(AsyncState.success(true));
      },
      failure: (message) {
        signInBroadcast.add(AsyncState.failure(message));
      },
    );
  }

  // void resetPassword(String email) async {
  //   resetPasswordBroadcast.add(const AsyncState.loading());
  //   final result = await _loginRepository.resetPassword(email);
  //   result.when(
  //     success: (role) {
  //       resetPasswordBroadcast.add(AsyncState.success(true));
  //     },
  //     failure: (message) {
  //       resetPasswordBroadcast.add(AsyncState.failure(message));
  //     },
  //   );
  // }

  void register(String username,String email,String password,int role) async {
    registerBroadcast.add(const AsyncState.loading());
    final result = await _authRepository.register(username, email,password, role );
    result.when(
      success: (_) => registerBroadcast.add(const AsyncState.success(true)),
      failure: (message) => registerBroadcast.add(AsyncState.failure(message)),
    );
  }

  void updateUser({
    required int id,
    String? photoUrl,
    String? phoneNumber,
    String? name,
    String? school,
    String? grade,
    String? address,
    String? state,
    String? bio,
  }) async {
    updateBroadcast.add(const AsyncState.loading());
    final result = await _authRepository.updateUser(
      id,
      photoUrl,
      phoneNumber,
      name,
      school,
      grade,
      address,
      state,
      bio
    );
    result.when(
      success: (_) => updateBroadcast.add(const AsyncState.success(true)),
      failure: (message) => updateBroadcast.add(AsyncState.failure(message)),
    );
  }

  // void logout() async {
  //   logoutBroadcast.add(const AsyncState.loading());
  //   final result = await _loginRepository.logout();
  //   result.when(
  //       success: (user) {
  //         logoutBroadcast.add(AsyncState.success(true));
  //       },
  //       failure: (message) {
  //         logoutBroadcast.add(AsyncState.failure(message));
  //       }
  //   );
  // }

  void dispose() {
    signInBroadcast.close();
    registerBroadcast.close();
    updateBroadcast.close();
  }
}
