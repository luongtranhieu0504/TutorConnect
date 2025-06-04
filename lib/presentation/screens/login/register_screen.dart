import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/presentation/navigation/route_model.dart';
import 'package:tutorconnect/presentation/widgets/phone_text_field.dart';
import 'package:tutorconnect/presentation/widgets/photo_button.dart';
import 'package:tutorconnect/presentation/widgets/text_field_common.dart';
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;
  int? _roleId;


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
        context.push(Routes.loginPage);
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
                  "Username:",
                  style: AppTextStyles(context).bodyText1,
                ),
                const SizedBox(height: 8),
                TextFieldCommon(
                  controller: _nameController,
                  labelText: "Nhập email",
                ),
                const SizedBox(height: 24),
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
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                    _roleId = value == 'Student' ? 3 : 4;
                  },
                  items: ['Student', 'Tutor'].map((role) {
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
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    if (_roleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng chọn vai trò")),
      );
      return;
    }
    String password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }
    _bloc.register(name, email, password, _roleId!);
  }
}

