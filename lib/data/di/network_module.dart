import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tutorconnect/data/network/api/comment_api.dart';
import 'package:tutorconnect/data/network/api/conversation_api.dart';
import 'package:tutorconnect/data/network/api/message_api.dart';
import 'package:tutorconnect/data/network/api/post_api.dart';
import 'package:tutorconnect/data/network/api/review_api.dart';
import 'package:tutorconnect/data/network/api/schedule_api.dart';
import 'package:tutorconnect/data/network/api/student_api.dart';
import 'package:tutorconnect/data/network/api/tutor_api.dart';
import '../network/api/auth_api.dart';
import '../network/client.dart';

@module
abstract class NetworkModule {

  @singleton
  Dio provideDio(Client client) => client.build();

  @singleton
  AuthApi provideAuthApi(Dio dio) => AuthApi(dio);

  @singleton
  StudentApi provideStudentApi(Dio dio) => StudentApi(dio);

  @singleton
  TutorApi provideTutorApi(Dio dio) => TutorApi(dio);

  @singleton
  ReviewApi provideReviewApi(Dio dio) => ReviewApi(dio);

  @singleton
  ConversationApi provideConversationApi(Dio dio) => ConversationApi(dio);

  @singleton
  MessageApi provideMessageApi(Dio dio) => MessageApi(dio);

  @singleton
  ScheduleApi provideScheduleApi(Dio dio) => ScheduleApi(dio);

  @singleton
  PostApi providePostApi(Dio dio) => PostApi(dio);

  @singleton
  CommentApi provideCommentApi(Dio dio) => CommentApi(dio);
}