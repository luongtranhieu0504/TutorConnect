import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../manager/account.dart';
import '../network/api/auth_api.dart';
import '../network/dto/login_req_dto.dart';
import '../network/dto/login_res_dto.dart';
import '../network/dto/register_req_dto.dart';
import '../network/dto/response_dto.dart';
import '../network/dto/update_user_req_dto.dart';
import '../network/dto/user_dto.dart';
import 'package:path/path.dart';

@singleton
class AuthNetworkDataSource {
  final AuthApi _authApi;

  AuthNetworkDataSource(this._authApi);

  Future<ResponseDto<LoginResDto>> signIn(LoginReqDto loginReqDto) => _authApi.signIn(loginReqDto);

  Future<ResponseDto<LoginResDto>> register(RegisterReqDto registerReqDto) =>
      _authApi.register(registerReqDto);

  Future<ResponseDto<UserDto>> updateUser(int id, Map<String, dynamic> data) =>
      _authApi.updateUser(id, data);

  Future<ResponseDto<UserDto>> updateUserStatus(int userId, Map<String, dynamic> data) =>
      _authApi.updateUserStatus(userId, data);

  Future<ResponseDto<UserDto>> getUserById(int id) =>
      _authApi.getUserById(id);




}