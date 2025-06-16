import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/mapper/user_mapper.dart';
import '../../common/task_result.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../manager/account.dart';
import '../manager/status.dart';
import '../network/api_call.dart';
import '../network/dto/register_req_dto.dart';
import '../network/dto/update_user_req_dto.dart';
import '../source/auth_disk_data_source.dart';
import '../source/auth_network_data_source.dart';
import '../network/dto/login_req_dto.dart';

@Singleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDiskDataSource _authDiskDataSource;
  final AuthNetworkDataSource _authNetworkDataSource;

  AuthRepositoryImpl(
    this._authDiskDataSource,
    this._authNetworkDataSource,
  );

  @override
  Future<TaskResult<bool>> signIn(String identifier, String password) =>
      callApi(() async {
        // Clear previous token first
        await _authDiskDataSource.clearToken();
        final authDto = LoginReqDto(identifier, password);
        final responseDto = await _authNetworkDataSource.signIn(authDto);
        final loginResDto = responseDto.data!;

        _authDiskDataSource.saveToken(loginResDto.token!);

        final user = loginResDto.user?.toModel();
        Account.instance.saveUser(user, token: loginResDto.token);

        await StatusManager.instance.setUserOnline(user!.id);

        // final fcmToken = await FirebaseMessaging.instance.getToken();
        // if (fcmToken != null) {
        //   await saveFcmToken(fcmToken);
        // }
        return true;
      });

  @override
  Future<TaskResult<bool>> register(
          String username, String email, String password, int role) =>
      callApi(() async {
        // Clear previous token first
        await _authDiskDataSource.clearToken();
        final registerDto = RegisterReqDto(username, email, password, role);
        final responseDto = await _authNetworkDataSource.register(registerDto);
        final loginResDto = responseDto.data!;

        _authDiskDataSource.saveToken(loginResDto.token!);

        final user = loginResDto.user?.toModel();
        Account.instance.saveUser(user, token: loginResDto.token);

        return true;
      });

  @override
  Future<TaskResult<bool>> logout() => callApi(() async {
    if (Account.instance.user.id != 0) {
      await StatusManager.instance.setUserOffline(Account.instance.user.id);
    }
    // Clear token from storage
    await _authDiskDataSource.clearToken();

    // Clear user data from singleton
    Account.instance.logout();
    return true;
  });

  @override
  Future<TaskResult<bool>> updateUser(
    int id,
    String? photoUrl,
    String? phoneNumber,
    String? name,
    String? school,
    String? grade,
    String? address,
    String? state,
    String? bio,
  ) =>
      callApi(() async {
        final updateUserDto = UpdateUserReqDto(
          phoneNumber: phoneNumber,
          photoUrl: photoUrl,
          name: name,
          school: school,
          grade: grade,
          address: address,
          state: state,
          bio: bio,
        );

        final responseDto =
            await _authNetworkDataSource.updateUser(id, updateUserDto);
        final userDto = responseDto.data!;

        final user = userDto.toModel();
        Account.instance.saveUser(user);

        return true;
      });


  @override
  Future<TaskResult<bool>> saveFcmToken(String? token) =>
      callApi(() async {
        final id = Account.instance.user.id;

        // Fetch current user data
        final currentUserResponse = await _authNetworkDataSource.getUserById(id);
        final currentUser = currentUserResponse.data;

        // Merge current user data with new fcmToken
        final updateUserDto = UpdateUserReqDto(
          fcmToken: token,
          photoUrl: currentUser?.photoUrl,
          phoneNumber: currentUser?.phone,
          name: currentUser?.name,
          school: currentUser?.school,
          grade: currentUser?.grade,
          address: currentUser?.address,
          state: currentUser?.state,
          bio: currentUser?.bio,
        );

        // Update user with merged data
        final responseDto =
        await _authNetworkDataSource.updateUser(id, updateUserDto);
        final userDto = responseDto.data!;
        final user = userDto.toModel();
        Account.instance.saveUser(user);
        return true;
      });

  @override
  Future<TaskResult<User?>> getUserById(int id) => callApi(() async {
    final response= await _authNetworkDataSource.getUserById(id);
    final user = response.data!.toModel();
    return user;
  });



}
