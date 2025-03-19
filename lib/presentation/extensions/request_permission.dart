import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// 📌 Hàm yêu cầu quyền và chọn ảnh/chụp ảnh
  static Future<File?> requestPermissionAndPickImage(BuildContext context) async {
    PermissionStatus cameraStatus = await Permission.camera.request();
    PermissionStatus storageStatus = await Permission.storage.request();

    if (cameraStatus.isGranted && storageStatus.isGranted) {
      return await _showImageSourceDialog(context);
    } else {
      _showPermissionDeniedDialog(context);
      return null;
    }
  }

  /// 📌 Hiển thị hộp thoại chọn nguồn ảnh
  static Future<File?> _showImageSourceDialog(BuildContext context) async {
    return await showModalBottomSheet<File?>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Chụp ảnh'),
              onTap: () async {
                Navigator.pop(context, await _pickImage(ImageSource.camera));
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Chọn từ thư viện'),
              onTap: () async {
                Navigator.pop(context, await _pickImage(ImageSource.gallery));
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 📌 Hiển thị cảnh báo nếu quyền bị từ chối
  static void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quyền bị từ chối'),
        content: Text('Bạn cần cấp quyền Camera và Ảnh để tiếp tục.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings(); // Mở cài đặt để cấp quyền
            },
            child: Text('Mở cài đặt'),
          ),
        ],
      ),
    );
  }

  /// 📌 Chọn ảnh từ thư viện hoặc chụp ảnh
  static Future<File?> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
