import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/presentation/widgets/phone_text_field.dart';
import 'package:tutorconnect/presentation/widgets/photo_button.dart';
import 'package:tutorconnect/presentation/widgets/text_field_default.dart';

import '../../../di/di.dart';
import '../../../theme/color_platte.dart';
import '../../../theme/text_styles.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/email_text_field.dart';
import '../../widgets/or_divider.dart';
import '../../widgets/password_text_field.dart';
import 'login_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _bloc = getIt<LoginBloc>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    _bloc.registerBroadcast.listen((state) {
      state.when(loading: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
      }, success: (data) {
        context.pop(); // Đóng loading dialog
        context.go('/user-detail', extra: data);
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
          title: Text('Đăng Ký', style: AppTextStyles(context).headingMedium),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Email:",
                  style: AppTextStyles(context).bodyText1,
                ),
                const SizedBox(height: 8),
                EmailTextField(
                  controller: _emailController,
                  labelText: "Nhập email",
                ),
                const SizedBox(height: 24),
                Text(
                  "Mật khẩu:",
                  style: AppTextStyles(context).bodyText1,
                ),
                const SizedBox(height: 8),
                PasswordTextField(
                  controller: _passwordController,
                  labelText: "Nhập mật khẩu",
                ),
                const SizedBox(height: 12),
                Text(
                  "Vai trò:",
                  style: AppTextStyles(context).bodyText1,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  items: ['Học sinh', 'Gia sư'].map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  hint: Text('Chọn vai trò'),
                  decoration: InputDecoration(
                    hintText: 'Vai trò',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ProjectButton(
                  title: "Đăng Ký",
                  color: AppColors.colorButton,
                  textColor: Colors.white,
                  onPressed: () => _signUp(),
                ),
                const SizedBox(height: 24),
                Center(
                  child: RichText(
                    text: TextSpan(
                        text: "Bạn có tài khoản? ",
                        style: AppTextStyles(context).bodyText1
                            .copyWith(color: Color(0xFF64748B)),
                        children: [
                          WidgetSpan(
                              child: GestureDetector(
                                  onTap: () {
                                    context.go('/login');
                                  },
                                  child: Text(
                                    "Đăng nhập",
                                    style: AppTextStyles(context).bodyText1
                                        .copyWith(color: AppColors.colorButton),
                                  ))),
                        ]),
                  ),
                ),
                const SizedBox(height: 32),
                OrDivider(),
                const SizedBox(height: 32),
                SocialButton(
                  title: "Google",
                  iconPath: 'assets/icons/Google.svg',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ));
  }

  void _signUp() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn vai trò")),
      );
      return;
    }
    _bloc.signUp(email, password,_selectedRole);
  }
}

class UserDetailScreen extends StatefulWidget {
  final String uid;

  const UserDetailScreen({super.key, required this.uid});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? _photoUrl;
  final _bloc = getIt<LoginBloc>();

  @override
  initState() {
    super.initState();
    _bloc.signInBroadcast.listen((state) {
      state.when(loading: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
      }, success: (data) {
        context.pop(); // Đóng loading dialog
        context.go('/main');
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
                    UploadPhotoButton(),
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
                controller: _schoolController,
                labelText: "Trường",
                icon: Icons.school,
              ),
              const SizedBox(height: 12.0),
              TextFieldDefault(
                controller: _gradeController,
                labelText: "Lớp",
                icon: Icons.school,
              ),
              const SizedBox(height: 12.0),
              TextFieldDefault(
                controller: _bioController,
                maxLines: 5,
                labelText: "Giới thiệu",
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

  void _saveUserDetail() {

    Map<String, dynamic> data = {
      "name": _nameController.text.trim(),
      "school": _schoolController.text.trim(),
      "grade": _gradeController.text.trim(),
      "phone": _phoneController.text.trim(),
      "photoUrl": _photoUrl,
      "bio": _bioController.text.trim(),
    };

    _bloc.updateUser(widget.uid, data);
  }
}
