import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  final BuildContext context;
  AppTextStyles(this.context);

  TextStyle get headingMedium => GoogleFonts.interTight(
    fontSize: 32,
    fontWeight: FontWeight.normal,
    color: Theme.of(context).textTheme.headlineMedium?.color,
  );

  TextStyle get headingSemiBold => GoogleFonts.interTight(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).textTheme.headlineSmall?.color,
  );

  TextStyle get headingBold => GoogleFonts.interTight(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).textTheme.headlineSmall?.color,
  );

  TextStyle get bodyText1 => GoogleFonts.interTight(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).textTheme.bodyLarge?.color,
  );

  TextStyle get bodyText2 => GoogleFonts.interTight(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Theme.of(context).textTheme.bodySmall?.color,
  );
}
