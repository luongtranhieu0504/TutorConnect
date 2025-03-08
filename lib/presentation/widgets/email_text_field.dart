import 'package:flutter/material.dart';

import '../../theme/color_platte.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;

  const EmailTextField({super.key, this.controller, this.labelText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(Icons.email_outlined),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.colorButton, width: 2),
              borderRadius: BorderRadius.circular(10)
          )
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
      )
    );
  }
}
