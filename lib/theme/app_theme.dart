import 'package:flutter/material.dart';
import 'color_platte.dart';
import 'text_styles.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  textTheme: TextTheme(
    headlineMedium: AppTextStyles.headingMedium,
    headlineSmall: AppTextStyles.headingSemiBold,
    bodyLarge: AppTextStyles.bodyText1,
    bodySmall: AppTextStyles.bodyText2,
  ),
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.background,
  ),
);
