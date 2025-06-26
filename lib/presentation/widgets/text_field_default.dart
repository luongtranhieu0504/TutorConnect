import 'package:flutter/material.dart';
import 'package:tutorconnect/theme/color_platte.dart';

class TextFieldDefault extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final int maxLines;
  final IconData? icon;

  const TextFieldDefault(
      {super.key,
      this.controller,
      this.labelText,
      this.maxLines = 1,
      this.icon, required
      String hintText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(color: AppColors.color500),
              hintText: 'Enter $labelText',
              prefixIcon: Icon(icon),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.colorButton, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              alignLabelWithHint: true),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          maxLines: maxLines,
        )
    );
  }
}
