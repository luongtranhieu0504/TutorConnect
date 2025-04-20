import 'package:flutter/material.dart';
import 'package:tutorconnect/theme/color_platte.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final ValueChanged<String>? onSubmitted;

  const SearchTextField(
      {super.key,
        this.controller,
        this.labelText,
        this.onSubmitted,
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(Icons.search, color: AppColors.color500),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: AppColors.colorButton, width: 2),
                borderRadius: BorderRadius.circular(10)),
            alignLabelWithHint: true,
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          onSubmitted: onSubmitted,
        )
    );
  }
}





