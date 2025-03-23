import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// ✅ Trả về màu icon phù hợp với dark/light mode
Color iconColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : Colors.black;
}

/// ✅ Icon dùng lại, auto màu
Widget themedIcon(IconData icon, BuildContext context, {double size = 24}) {
  return Icon(
    icon,
    size: size,
    color: iconColor(context),
  );
}

/// ✅ SVG dùng lại, auto màu
Widget themedSvgAsset(String assetPath, BuildContext context, {double size = 24}) {
  return SvgPicture.asset(
    assetPath,
    height: size,
    width: size,
    color: iconColor(context),
  );
}
