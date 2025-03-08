import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSaved;

  const PhoneTextField({
    Key? key,
    required this.controller,
    this.onChanged,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(),
        ),
      ),
      initialCountryCode: 'VN', // Mặc định là Việt Nam
      onChanged: (phone) {
        if (onChanged != null) onChanged!(phone.completeNumber);
      },
      onSaved: (phone) {
        if (onSaved != null) onSaved!(phone!.completeNumber);
      },
    );
  }
}
