
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorconnect/config/app_config.dart';
import 'package:tutorconnect/data/manager/account.dart';
import 'package:tutorconnect/presentation/navigation/route.dart';
import 'package:tutorconnect/theme/app_theme.dart';
import 'package:tutorconnect/theme/theme_provider.dart';
import 'config/map_config.dart';
import 'di/di.dart';
import 'package:timezone/data/latest.dart' as tz;


Future<void> main() async {
  AppConfig.isProd = true;
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await setupMapConfig();
  tz.initializeTimeZones();
  await Account.instance.initialize();
  final isLoggedIn = Account.instance.isLoggedIn;

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(
          startupLoggedIn: isLoggedIn), // Bây giờ context của MyApp có Provider ở trên!
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool startupLoggedIn;

  const MyApp({super.key, required this.startupLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    if (widget.startupLoggedIn) {
      // 🔥 Gọi sau khi có user
      // NotificationService().initialize(context);
    }
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
      routerConfig: router,
    );
  }
}


