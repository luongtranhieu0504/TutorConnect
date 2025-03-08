import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/text_styles.dart';

class ProjectButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const ProjectButton(
      {super.key,
      required this.title,
      required this.color,
      required this.textColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: AppTextStyles.bodyText1.copyWith(color: textColor),
        )
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onPressed;
  const SocialButton({super.key, required this.title, required this.iconPath, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        icon: SvgPicture.asset(iconPath, width: 24, height: 24),
        label: Text("Continue with $title", style: AppTextStyles.bodyText1,),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        )
      ),
    );
  }
}

