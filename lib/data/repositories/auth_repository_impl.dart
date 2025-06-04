import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/mapper/user_mapper.dart';
import '../../common/task_result.dart';
import '../../domain/repository/auth_repository.dart';
import '../manager/account.dart';
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
  Future<TaskResult<bool>> updateUser(
    int id,
    String? username,
    String? email,
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
          username: username,
          email: email,
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
}
