import 'dart:io';
import 'package:flutter/material.dart';

import '../extensions/request_permission.dart';

class UploadPhotoButton extends StatefulWidget {
  final void Function(File)? onImageSelected;
  final String? initialPhotoUrl;

  const UploadPhotoButton({
    super.key,
    this.onImageSelected,
    this.initialPhotoUrl,
  });

  @override
  State<UploadPhotoButton> createState() => _UploadPhotoButtonState();
}

class _UploadPhotoButtonState extends State<UploadPhotoButton> {
  File? _image;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _photoUrl = widget.initialPhotoUrl;
  }

  Future<void> _pickImage() async {
    File? selectedImage =
    await ImagePickerHelper.requestPermissionAndPickImage(context);
    if (selectedImage != null) {
      setState(() {
        _image = selectedImage;
        _photoUrl = null; // Reset nếu có ảnh local mới
      });
      widget.onImageSelected?.call(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    DecorationImage? decorationImage;
    if (_image != null) {
      decorationImage = DecorationImage(
        image: FileImage(_image!),
        fit: BoxFit.cover,
      );
    } else if (_photoUrl != null && _photoUrl!.isNotEmpty) {
      decorationImage = DecorationImage(
        image: NetworkImage(_photoUrl!),
        fit: BoxFit.cover,
      );
    }

    return GestureDetector(
      onTap: _pickImage,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: (_image == null && (_photoUrl == null || _photoUrl!.isEmpty))
                  ? const LinearGradient(
                colors: [Color(0xFFD9B3FF), Color(0xFFF0E0FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
                  : null,
              image: decorationImage,
              border: Border.all(
                color: Colors.purple.shade300,
                width: 1.5,
              ),
            ),
            child: (_image == null && (_photoUrl == null || _photoUrl!.isEmpty))
                ? const Icon(
              Icons.camera_alt_outlined,
              size: 32,
              color: Colors.purple,
            )
                : null,
          ),
        ],
      ),
    );
  }
}
