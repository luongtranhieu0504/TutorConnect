import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_platte.dart';

class AppTextStyles {
  static final headingMedium = GoogleFonts.interTight(
    fontSize: 32,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static final headingSemiBold = GoogleFonts.interTight(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final headingBold = GoogleFonts.interTight(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final bodyText1 = GoogleFonts.interTight(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final bodyText2 = GoogleFonts.interTight(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}
