import 'dart:io';
import 'package:flutter/material.dart';

import '../extensions/request_permission.dart';

class UploadPhotoButton extends StatefulWidget {
  final void Function(File)? onImageSelected;
  const UploadPhotoButton({super.key, this.onImageSelected});

  @override
  State<UploadPhotoButton> createState() => _UploadPhotoButtonState();
}

class _UploadPhotoButtonState extends State<UploadPhotoButton> {
  File? _image;

  Future<void> _pickImage() async {
    File? selectedImage =
        await ImagePickerHelper.requestPermissionAndPickImage(context);
    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
      });
      widget.onImageSelected?.call(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _pickImage();
        },
        child: Column(
          children: [
            Container(
              width: 76, // Giảm size khoảng 24% so với 100px
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _image == null
                    ? const LinearGradient(
                        colors: [Color(0xFFD9B3FF), Color(0xFFF0E0FF)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                image: _image != null
                    ? DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      )
                    : null,
                border: Border.all(
                  color: Colors.purple.shade300,
                  width: 1.5,
                ),
              ),
              child: _image == null
                  ? const Icon(
                Icons.camera_alt_outlined,
                size: 32,
                color: Colors.purple,
              )
                  : null,
            ),
          ],
        ));
  }
}
