import 'package:flutter/material.dart';
import 'package:tutorconnect/presentation/screens/login/login_screen.dart';
import 'package:tutorconnect/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TutorConnect',
      theme: appTheme,
      home: OtpVerificationScreen(),
    );
  }
}

