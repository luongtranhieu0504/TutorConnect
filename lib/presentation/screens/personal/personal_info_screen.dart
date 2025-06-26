import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tutorconnect/data/manager/account.dart';
import 'package:tutorconnect/theme/color_platte.dart';
import 'package:tutorconnect/theme/text_styles.dart';
import 'package:tutorconnect/common/services/cloudinary_service.dart';
import 'package:tutorconnect/di/di.dart';
import 'package:tutorconnect/domain/services/strapi_service.dart';
import 'package:tutorconnect/presentation/widgets/button_custom.dart';
import 'package:tutorconnect/presentation/widgets/text_field_default.dart';
import 'package:tutorconnect/presentation/widgets/photo_button.dart';

import '../login/login_bloc.dart';


class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final user = Account.instance.user;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _selectedImage;
  String? _photoUrl;
  StrapiService strapiService = StrapiService();

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _emailController.text = user.email ?? '';
    _nameController.text = user.name ?? '';
    _schoolController.text = user.school ?? '';
    _gradeController.text = user.grade ?? '';
    _phoneController.text = user.phone ?? '';
    _addressController.text = user.address ?? '';
    _photoUrl = user.photoUrl;
  }

  Future<void> _saveChanges() async {
    try {
      String? uploadedUrl;
      if (_selectedImage != null) {
        final result = await uploadToCloudinary(_selectedImage!, 'image');
        if (result != null && result.containsKey('url')) {
          uploadedUrl = result['url'];
        }
      }

      getIt<LoginBloc>().updateUser(user.id, user.copyWith(
        email: _emailController.text,
        name: _nameController.text,
        school: _schoolController.text,
        grade: _gradeController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        photoUrl: uploadedUrl ?? _photoUrl,
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving changes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Personal Info', style: AppTextStyles(context).headingMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  UploadPhotoButton(
                    initialPhotoUrl: _photoUrl,
                    onImageSelected: (image) {
                      setState(() {
                        _selectedImage = image;
                      });
                    },
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    "Tap the circle to update your photo",
                    style: AppTextStyles(context).bodyText1.copyWith(color: AppColors.color900),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            TextFieldDefault(
              controller: _emailController,
              labelText: "Email",
              icon: Icons.email,
              hintText: "Enter your email",
            ),
            const SizedBox(height: 12.0),
            TextFieldDefault(
              controller: _nameController,
              labelText: "Name",
              icon: Icons.person,
              hintText: "Enter your name",
            ),
            const SizedBox(height: 12.0),
            TextFieldDefault(
              controller: _schoolController,
              labelText: "School",
              icon: Icons.school,
              hintText: "Enter your school",
            ),
            const SizedBox(height: 12.0),
            TextFieldDefault(
              controller: _gradeController,
              labelText: "Grade",
              icon: Icons.grade,
              hintText: "Enter your grade",
            ),
            const SizedBox(height: 12.0),
            TextFieldDefault(
              controller: _phoneController,
              labelText: "Phone",
              icon: Icons.phone,
              hintText: "Enter your phone number",
            ),
            const SizedBox(height: 12.0),
            TextFieldDefault(
              controller: _bioController,
              labelText: "Bio",
              icon: Icons.info,
              hintText: "Enter your bio",
            ),
            const SizedBox(height: 12.0),
            TextFieldDefault(
              controller: _addressController,
              labelText: "Address",
              icon: Icons.home,
              hintText: "Enter your address",
            ),
            const SizedBox(height: 24.0),
            ProjectButton(
              title: "Save Changes",
              color: AppColors.colorButton,
              textColor: Colors.white,
              onPressed: _saveChanges,
            ),
          ],
        ),
      ),
    );
  }
}