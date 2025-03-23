import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/presentation/navigation/layout_scaffold.dart';
import 'package:tutorconnect/presentation/navigation/route_model.dart';
import 'package:tutorconnect/presentation/screens/history_session/history_session_screen.dart';
import 'package:tutorconnect/presentation/screens/scheduall/scheduall_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/login/register_screen.dart';
import '../screens/main_screen.dart';
import '../screens/message/message_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/student/home/student_home_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.homePage,
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
              path: Routes.homePage,
              builder: (context, state) => const StudentHomeScreen(),
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
      path: Routes.mainPage,
      builder: (context, state) => const MainScreen(),
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
    )
  ],
);
