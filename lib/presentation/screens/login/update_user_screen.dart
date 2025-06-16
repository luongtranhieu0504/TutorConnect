import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/data/manager/account.dart';

import '../../../common/services/cloudinary_service.dart';
import '../../../di/di.dart';
import '../../../domain/services/strapi_service.dart';
import '../../../theme/color_platte.dart';
import '../../../theme/text_styles.dart';
import '../../navigation/route_model.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/phone_text_field.dart';
import '../../widgets/photo_button.dart';
import '../../widgets/text_field_default.dart';
import 'login_bloc.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key});

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _bloc = getIt<LoginBloc>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _photoUrl;
  File? _selectedImage;
  final user = Account.instance.user;
  List<dynamic> mediaFiles = [];
  StrapiService strapiService = StrapiService();


  @override
  initState() {
    super.initState();
    _bloc.updateBroadcast.listen((state) {
      state.when(loading: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
      }, success: (data) {
        context.pop(); // Close loading dialog

        if (user.typeRole != null) {
          // User doesn't have a role yet, navigate to update screen
          context.push(Routes.mainPage, extra: {
            'role': user.typeRole,
            'id': user.id,
          });
        }
      }, failure: (message) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin cá nhân', style: AppTextStyles(context).headingMedium),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    UploadPhotoButton(
                      onImageSelected: (image) {
                        setState(() {
                          _selectedImage = image;
                        });
                      },
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      "Nhấn vào hình tròn để\nCập nhật hình của bạn",
                      style: AppTextStyles(context).bodyText1.copyWith(color: AppColors.color900),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              TextFieldDefault(
                controller: _nameController,
                labelText: "Họ và tên",
                icon: Icons.person,
              ),
              const SizedBox(height: 12.0),
              PhoneTextField(
                controller: _phoneController,
              ),
              const SizedBox(height: 12.0),
              TextFieldDefault(
                controller: _addressController,
                labelText: "Địa chỉ",
                icon: Icons.home_work_sharp,
              ),
              const SizedBox(height: 12.0),
              ProjectButton(
                title: "Lưu",
                color: AppColors.colorButton,
                textColor: Colors.white,
                onPressed: () => _saveUserDetail(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveUserDetail() async {
    try {
      String? uploadedUrl;
      if (_selectedImage != null) {
        // Upload to Cloudinary instead of Strapi
        final result = await uploadToCloudinary(_selectedImage!, 'image');

        if (result != null && result.containsKey('url')) {
          uploadedUrl = result['url'];
        }
      }
      _bloc.updateUser(
        id: user.id,
        phoneNumber: _phoneController.text,
        name: _nameController.text,
        address: _addressController.text,
        photoUrl: uploadedUrl,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user: $e')),
      );
      print('Error in _saveUserDetail: $e');
    }
  }



}
