import 'package:flutter/material.dart';
import 'package:tutorconnect/theme/color_platte.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;

  const PasswordTextField({super.key, this.controller, this.labelText});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  var _visiblePassword = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            prefixIcon: Icon(Icons.punch_clock_outlined),
            suffixIcon: IconButton(
                onPressed:() => setState(() {
                  _visiblePassword = !_visiblePassword;
                }),
                icon: Icon(
                  _visiblePassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                )
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(10)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.colorButton, width: 2),
                borderRadius: BorderRadius.circular(10)
            )
          ),
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          obscureText: !_visiblePassword,
        ));
  }
}


