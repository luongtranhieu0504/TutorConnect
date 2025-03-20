import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/di/di.dart';
import 'package:tutorconnect/presentation/navigation/route_model.dart';
import 'package:tutorconnect/presentation/widgets/button_custom.dart';
import 'package:tutorconnect/presentation/widgets/email_text_field.dart';
import 'package:tutorconnect/presentation/widgets/or_divider.dart';
import 'package:tutorconnect/presentation/widgets/password_text_field.dart';
import 'package:tutorconnect/theme/color_platte.dart';
import '../../../theme/text_styles.dart';
import 'login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _bloc = getIt<LoginBloc>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _bloc.signInBroadcast.listen((state) {
      state.when(
        loading: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        },
        success: (data) {
          context.go(Routes.homePage);
        },
        failure: (message) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Đăng nhập thất bại!")),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Đăng Nhập', style: AppTextStyles.headingMedium),
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                GestureDetector(
                  onTap: () {
                    context.go('/reset-password');
                  },
                  child: Text("Quên mật khẩu?",
                      style: AppTextStyles.bodyText1.copyWith(
                          color: AppColors.colorButton)),
                ),
                const SizedBox(height: 12),
                ProjectButton(
                  title: "Đăng Nhập",
                  color: AppColors.colorButton,
                  textColor: Colors.white,
                  onPressed: () => _signIn(),
                ),
                const SizedBox(height: 24),
                Center(
                  child: RichText(
                    text: TextSpan(
                        text: "Bạn chưa có tài khoản? ",
                        style: AppTextStyles.bodyText1
                            .copyWith(color: Color(0xFF64748B)),
                        children: [
                          WidgetSpan(
                              child: GestureDetector(
                                  onTap: () {
                                    context.go('/register');
                                  },
                                  child: Text(
                                    "Đăng kí",
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
          ),
        ));
  }

  void _signIn() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }
    _bloc.signIn(email, password);
  }
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final bloc = getIt<LoginBloc>();
    return Scaffold(
        appBar: AppBar(
          title: Text('Đặt lại mật khẩu', style: AppTextStyles.headingMedium),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Email:",
                    style: AppTextStyles.bodyText1,
                  ),
                  SizedBox(height: 8),
                  EmailTextField(
                    controller: emailController,
                    labelText: "Nhập email",
                  ),
                  SizedBox(height: 24),
                  ProjectButton(
                    title: "Đặt lại",
                    color: AppColors.colorButton,
                    textColor: Colors.white,
                    onPressed: () {
                      bloc.resetPassword(emailController.text);
                    },
                  )
                ]
            ),
          ),
        )
    );
  }
}


