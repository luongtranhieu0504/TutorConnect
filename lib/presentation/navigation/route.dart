import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/data/models/post.dart';
import 'package:tutorconnect/presentation/navigation/layout_scaffold.dart';
import 'package:tutorconnect/presentation/navigation/route_model.dart';
import 'package:tutorconnect/presentation/screens/comment/comment_screen.dart';
import 'package:tutorconnect/presentation/screens/history_session/history_session_screen.dart';
import 'package:tutorconnect/presentation/screens/post/post_screen.dart';
import 'package:tutorconnect/presentation/screens/scheduall/scheduall_screen.dart';
import '../../data/models/users.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/login/register_screen.dart';
import '../screens/main_screen.dart';
import '../screens/message/message_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/student/home/student_home_screen.dart';
import '../screens/student/tutor_map/tutor_map_screen.dart';
import '../screens/tutor/tutor_home/tutor_home_screen.dart';
import '../screens/tutor/tutor_profile/tutor_profile_screen.dart';

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
                final user = state.extra as UserModel?;
                if (user?.role == 'Gia sư') {
                  return const TutorHomeScreen();
                } else if (user?.role == 'Học sinh') {
                  return StudentHomeScreen(uid: user!.uid);
                } else {
                  return const LoginScreen(); // Fallback in case of invalid role
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
              builder: (context, state) {
                final user = state.extra as UserModel?;
                return ProfileScreen(
                  user: user!,
                );
              },
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
    // Màn hình Chat phải nằm ngoài StatefulShellRoute để mở đúng
    GoRoute(
      path: Routes.chatPage,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return ChatScreen(
          name: extra['name'] ?? '',
          subject: extra['subject'] ?? '',
          isOnline: extra['isOnline'] ?? false,
          avatarUrl: extra['avatarUrl'] ?? '',
        );
      },
    ),

    GoRoute(
      path: Routes.historySessionPage,
      builder: (context, state) => const HistorySessionScreen(),
    ),
    // GoRoute(
    //   path: Routes.resetPasswordPage,
    //   builder: (context, state) => const LoginScreen(),
    // ),
    // GoRoute(
    //   path: Routes.tutorDetailPage,
    //   builder: (context, state) => const LoginScreen(),
    // ),
    GoRoute(
      path: Routes.tutorMapPage,
      builder: (context, state) => const TutorMapScreen(),
    ),
    GoRoute(
      path: Routes.postCommentPage,
      builder: (context, state) {
        final post = state.extra as Post;
        return CommentScreen(post: post);
      },
    ),
    GoRoute(
      path: Routes.tutorProfilePage,
      builder: (context, state) => const TutorProfileScreen(),
    ),



  ],
);
