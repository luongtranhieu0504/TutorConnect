import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tutorconnect/config/app_config.dart';
import 'package:tutorconnect/data/manager/account.dart';
import 'package:tutorconnect/presentation/navigation/route.dart';
import 'package:tutorconnect/theme/app_theme.dart';
import 'package:tutorconnect/theme/theme_provider.dart';
import 'config/map_config.dart';
import 'data/manager/status.dart';
import 'data/network/socket/socket_service.dart';
import 'di/di.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'domain/services/notification_service.dart';

Future<void> main() async {
  AppConfig.isProd = true;
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();

  await Account.instance.initialize();
  StatusManager.instance.listenToAppLifecycle();
  await Firebase.initializeApp();
  await setupMapConfig();
  tz.initializeTimeZones();

  final isLoggedIn = Account.instance.isLoggedIn;

  // if (isLoggedIn) {
  //   getIt<SocketService>().init();
  // }


  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(
        startupLoggedIn: isLoggedIn,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool startupLoggedIn;
  const MyApp({
    super.key,
    required this.startupLoggedIn
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // if (widget.startupLoggedIn) {
    //   NotificationService().initialize(context);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      title: 'TutorConnect',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: router, // ✅ dùng router truyền vào
    );
  }
}
