import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneTextField extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSaved;

  const PhoneTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSaved,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
        LengthLimitingTextInputFormatter(11), // Giới hạn số điện thoại Việt Nam
      ],
      decoration: InputDecoration(
        labelText: 'Số điện thoại (+84)',
        prefixText: '+84 ', // Luôn hiển thị mã vùng Việt Nam
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(),
        ),
      ),
      onChanged: (value) {
        String formattedNumber = value.replaceAll(RegExp(r'[^0-9]'), '');
        if (widget.onChanged != null) {
          widget.onChanged!(formattedNumber);
        }
      },
      onSubmitted: (value) {
        String formattedNumber = "+84$value";
        print(formattedNumber);
        if (widget.onSaved != null) {
          widget.onSaved!(formattedNumber);
        }
      },
    );
  }
}
