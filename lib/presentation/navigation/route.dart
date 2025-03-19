import 'package:go_router/go_router.dart';

import '../screens/chat/chat_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/login/register_screen.dart';
import '../screens/main_screen.dart';
import '../screens/message/message_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/scheduall/scheduall_screen.dart';
import '../screens/student/home/student_home_screen.dart';

final GoRouter router = GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/user-detail',
        builder: (context, state) {
          final uid = state.extra as String;
          return UserDetailScreen(uid: uid);
        },
      ),
      GoRoute(
        path: '/student-home',
        builder: (context, state) => const StudentHomeScreen(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>; // Đảm bảo extra là Map
          return ChatScreen(
            name: extra['name'] as String,
            subject: extra['subject'] as String,
            isOnline: extra['isOnline'] as bool, // Lấy giá trị bool chính xác
            avatarUrl: extra['avatarUrl'] as String,
          );
        },
      ),
      // ShellRoute chứa navigation bar
      ShellRoute(
        builder: (context, state, child) {
          return HomeScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            redirect: (context, state) => '/home/student-home',
          ),
          GoRoute(path: '/home/student-home', builder: (context, state) => const StudentHomeScreen()),
          GoRoute(path: '/home/schedule', builder: (context, state) => const ScheduleScreen()),
          GoRoute(path: '/home/message', builder: (context, state) => const MessageScreen()),
          GoRoute(path: '/home/profile', builder: (context, state) => const ProfileScreen()),
        ],
      ),
    ]
);