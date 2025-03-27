import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutorconnect/presentation/screens/student/tutor_map/tutor_map_screen.dart';
import 'package:tutorconnect/theme/app_theme.dart';


Future<void> main() async {
  runApp(const TestApp());
}




class TestApp extends StatelessWidget {
  const TestApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      home: const TutorMapScreen(),
    );
  }
}