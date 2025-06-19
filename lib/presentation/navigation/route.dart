import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/domain/model/conversation.dart';
import 'package:tutorconnect/domain/model/other_user.dart';
import 'package:tutorconnect/domain/model/schedule.dart';
import 'package:tutorconnect/domain/model/student.dart';
import 'package:tutorconnect/presentation/navigation/route_model.dart';
import 'package:tutorconnect/presentation/screens/login/update_user_screen.dart';
import 'package:tutorconnect/presentation/screens/student/home/student_home_screen.dart';
import 'package:tutorconnect/presentation/screens/tutor/tutor_home/tutor_home_screen.dart';

import '../../data/manager/account.dart';
import '../../domain/model/tutor.dart';
import '../../domain/model/user.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/login/register_screen.dart';
import '../screens/message/message_screen.dart';
import '../screens/post/post_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/scheduall/calendar_screen.dart';
import '../screens/scheduall/schedule_form_screen.dart';
import '../screens/scheduall/schedule_screen.dart';
import '../screens/student/tutor_map/tutor_map_screen.dart';
import '../screens/tutor/tutor_profile/tutor_profile_screen.dart';
import 'layout_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.loginPage,
  routes: [
    // StatefulShellRoute chứa BottomNavigationBar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => LayoutScaffold(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.mainPage,
              builder: (context, state) {
                // Lấy thông tin người dùng từ state
                final data = state.extra as Map<String, dynamic>?;
                final role = data?['role'];
                if (role == 'Tutor') {
                  return TutorHomeScreen();
                } else if (role == 'Student') {
                  return StudentHomeScreen();
                } else {
                  return LoginScreen();
                }
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.postPage,
              builder: (context, state) => const PostScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.schedulePage,
              builder: (context, state) => const ScheduleScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.messagePage,
              builder: (context, state) => const MessageScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.profilePage,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    // Các màn hình ngoài BottomNavigationBar
    GoRoute(
      path: Routes.loginPage,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Routes.registerPage,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: Routes.updateUserPage,
      builder: (context, state) => const UpdateUserScreen(),
    ),

    // Màn hình Chat phải nằm ngoài StatefulShellRoute để mở đúng
    GoRoute(
      path: Routes.chatPage,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final userChat = extra['user'] as User;
        final conversation = extra['conversation'] as Conversation;
        return ChatScreen(
          conversation: conversation,
          user: userChat,
        );
      },
    ),
    //
    // GoRoute(
    //   path: Routes.historySessionPage,
    //   builder: (context, state) => const HistorySessionScreen(),
    // ),
    // // GoRoute(
    // //   path: Routes.resetPasswordPage,
    // //   builder: (context, state) => const LoginScreen(),
    // // ),
    // // GoRoute(
    // //   path: Routes.tutorDetailPage,
    // //   builder: (context, state) => const LoginScreen(),
    // // ),
    GoRoute(
      path: Routes.tutorMapPage,
      builder: (context, state) {
        return TutorMapScreen();
      },
    ),
    // GoRoute(
    //   path: Routes.postCommentPage,
    //   builder: (context, state) {
    //     final post = state.extra as Post;
    //     return CommentScreen(post: post);
    //   },
    // ),
    GoRoute(
        path: Routes.tutorProfilePage,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final tutor = extra['tutor'] as Tutor;
          final isCurrentUser = extra['isCurrentUser'] as bool;
          return TutorProfileScreen(
            tutor: tutor,
            isCurrentUser: isCurrentUser,
          );
        }
    ),
    GoRoute(
      path: Routes.scheduleFormPage,
      builder: (context , state) {
        final extra = state.extra as Map<String, dynamic>;
        final student = extra['student'] as Student;
        return ScheduleFormScreen(
          student: student,
        );
      },
    ),
    GoRoute(
      path: Routes.calendarPage,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final schedules = extra?['schedules'] as List<Schedule>;
        return CalendarScreen(
          schedules: schedules,
        );
      },
    )

  ],
);
