import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  @override
  void initState() {
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
          title: Text('Đăng Ký', style: AppTextStyles.headingMedium),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email:",
                style: AppTextStyles.bodyText1,
              ),
              const SizedBox(height: 8),
              EmailTextField(
                controller: _emailController,
                labelText: "Nhập email",
              ),
              const SizedBox(height: 24),
              Text(
                "Mật khẩu:",
                style: AppTextStyles.bodyText1,
              ),
              const SizedBox(height: 8),
              PasswordTextField(
                controller: _passwordController,
                labelText: "Nhập mật khẩu",
              ),
              const SizedBox(height: 12),
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
                      style: AppTextStyles.bodyText1
                          .copyWith(color: Color(0xFF64748B)),
                      children: [
                        WidgetSpan(
                            child: GestureDetector(
                                onTap: () {
                                  context.go('/login');
                                },
                                child: Text(
                                  "Đăng nhập",
                                  style: AppTextStyles.bodyText1
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
    _bloc.signUp(email, password);
  }
}
