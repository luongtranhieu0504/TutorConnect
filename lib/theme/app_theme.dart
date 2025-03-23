import 'package:flutter/material.dart';
import 'color_platte.dart';
import 'text_styles.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.lightBackground,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.lightBackground,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.lightBackground,
    elevation: 2,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  textTheme: GoogleFonts.interTightTextTheme().copyWith(
    headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.normal, color: Colors.black),
    headlineSmall: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
  ),
);



final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.darkBackground,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.darkBackground,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.darkBackground,
    elevation: 2,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: GoogleFonts.interTightTextTheme().copyWith(
    headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.normal, color: Colors.white),
    headlineSmall: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade300),
  ),
);

