// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:tutorconnect/data/di/network_module.dart' as _i728;
import 'package:tutorconnect/data/network/api/auth_api.dart' as _i958;
import 'package:tutorconnect/data/network/api/conversation_api.dart' as _i881;
import 'package:tutorconnect/data/network/api/review_api.dart' as _i544;
import 'package:tutorconnect/data/network/api/student_api.dart' as _i955;
import 'package:tutorconnect/data/network/api/tutor_api.dart' as _i494;
import 'package:tutorconnect/data/network/client.dart' as _i473;
import 'package:tutorconnect/data/network/interceptor/auth_interceptor.dart'
    as _i999;
import 'package:tutorconnect/data/repositories/auth_repository_impl.dart'
    as _i2;
import 'package:tutorconnect/data/repositories/review_repositpry_impl.dart'
    as _i1060;
import 'package:tutorconnect/data/repositories/student_home_repository_impl.dart'
    as _i918;
import 'package:tutorconnect/data/repositories/tutor_repository_impl.dart'
    as _i184;
import 'package:tutorconnect/data/source/auth_disk_data_source.dart' as _i481;
import 'package:tutorconnect/data/source/auth_network_data_source.dart'
    as _i421;
import 'package:tutorconnect/data/source/review_network_data_source.dart'
    as _i940;
import 'package:tutorconnect/data/source/student_network_data_source.dart'
    as _i93;
import 'package:tutorconnect/data/source/tutor_network_data_source.dart'
    as _i315;
import 'package:tutorconnect/domain/repository/auth_repository.dart' as _i11;
import 'package:tutorconnect/domain/repository/review_repository.dart' as _i901;
import 'package:tutorconnect/domain/repository/student_home_repository.dart'
    as _i1073;
import 'package:tutorconnect/domain/repository/tutor_repository.dart' as _i437;
import 'package:tutorconnect/presentation/screens/login/login_bloc.dart'
    as _i667;
import 'package:tutorconnect/presentation/screens/profile/profile_bloc.dart'
    as _i971;
import 'package:tutorconnect/presentation/screens/student/home/student_home_bloc.dart'
    as _i1059;
import 'package:tutorconnect/presentation/screens/student/tutor_map/tutor_map_bloc.dart'
    as _i106;
import 'package:tutorconnect/presentation/screens/tutor/tutor_profile/tutor_profile_bloc.dart'
    as _i120;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    gh.factory<_i971.ProfileBloc>(() => _i971.ProfileBloc());
    gh.singleton<_i481.AuthDiskDataSource>(() => _i481.AuthDiskDataSource());
    gh.singleton<_i999.AuthInterceptor>(
        () => _i999.AuthInterceptor(gh<_i481.AuthDiskDataSource>()));
    gh.singleton<_i473.Client>(() => _i473.Client(gh<_i999.AuthInterceptor>()));
    gh.singleton<_i361.Dio>(() => networkModule.provideDio(gh<_i473.Client>()));
    gh.singleton<_i958.AuthApi>(
        () => networkModule.provideAuthApi(gh<_i361.Dio>()));
    gh.singleton<_i955.StudentApi>(
        () => networkModule.provideStudentApi(gh<_i361.Dio>()));
    gh.singleton<_i494.TutorApi>(
        () => networkModule.provideTutorApi(gh<_i361.Dio>()));
    gh.singleton<_i544.ReviewApi>(
        () => networkModule.provideReviewApi(gh<_i361.Dio>()));
    gh.singleton<_i881.ConversationApi>(
        () => networkModule.provideConversationApi(gh<_i361.Dio>()));
    gh.singleton<_i93.StudentNetworkDataSource>(
        () => _i93.StudentNetworkDataSource(gh<_i955.StudentApi>()));
    gh.singleton<_i1073.StudentHomeRepository>(() =>
        _i918.StudentHomeRepositoryImpl(gh<_i93.StudentNetworkDataSource>()));
    gh.singleton<_i421.AuthNetworkDataSource>(
        () => _i421.AuthNetworkDataSource(gh<_i958.AuthApi>()));
    gh.singleton<_i940.ReviewNetworkDataSource>(
        () => _i940.ReviewNetworkDataSource(gh<_i544.ReviewApi>()));
    gh.singleton<_i315.TutorNetworkDataSource>(
        () => _i315.TutorNetworkDataSource(gh<_i494.TutorApi>()));
    gh.singleton<_i901.ReviewRepository>(
        () => _i1060.ReviewRepositoryImpl(gh<_i940.ReviewNetworkDataSource>()));
    gh.factory<_i1059.StudentHomeBloc>(
        () => _i1059.StudentHomeBloc(gh<_i1073.StudentHomeRepository>()));
    gh.factory<_i120.TutorProfileBloc>(() => _i120.TutorProfileBloc(
          gh<_i901.ReviewRepository>(),
          gh<_i1073.StudentHomeRepository>(),
        ));
    gh.singleton<_i11.AuthRepository>(() => _i2.AuthRepositoryImpl(
          gh<_i481.AuthDiskDataSource>(),
          gh<_i421.AuthNetworkDataSource>(),
        ));
    gh.singleton<_i437.TutorRepository>(
        () => _i184.TutorRepositoryImpl(gh<_i315.TutorNetworkDataSource>()));
    gh.factory<_i667.LoginBloc>(
        () => _i667.LoginBloc(gh<_i11.AuthRepository>()));
    gh.factory<_i106.TutorMapBloc>(
        () => _i106.TutorMapBloc(gh<_i437.TutorRepository>()));
    return this;
  }
}

class _$NetworkModule extends _i728.NetworkModule {}
