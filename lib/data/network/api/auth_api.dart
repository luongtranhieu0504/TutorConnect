
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../dto/login_req_dto.dart';
import '../dto/login_res_dto.dart';
import '../dto/register_req_dto.dart';
import '../dto/response_dto.dart';
import '../dto/update_user_req_dto.dart';
import '../dto/user_dto.dart';


part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @POST('/api/auth/local')
  Future<ResponseDto<LoginResDto>> signIn(@Body() LoginReqDto dto);

  @POST('/api/auth/local/register')
  Future<ResponseDto<LoginResDto>> register(@Body() RegisterReqDto dto);

  @PUT('/api/users/{id}')
  Future<ResponseDto<UserDto>> updateUser(@Path("id") int id, @Body() UpdateUserReqDto dto);

  @PUT('/api/users/{id}')
  Future<ResponseDto<UserDto>> updateUserStatus(
      @Path('id') int userId,
      @Body() Map<String, dynamic> data
      );

  @GET('/api/users/{id}')
  Future<ResponseDto<UserDto>> getUserById(@Path('id') int id);

  @POST('/api/user/save-fcm-token')
  Future<void> saveFcmToken(@Body() Map<String, dynamic> body);


}
