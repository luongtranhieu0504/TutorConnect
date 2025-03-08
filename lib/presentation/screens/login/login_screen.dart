import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutorconnect/presentation/widgets/button_custom.dart';
import 'package:tutorconnect/presentation/widgets/or_divider.dart';
import 'package:tutorconnect/theme/color_platte.dart';

import '../../../theme/text_styles.dart';
import '../../widgets/phone_text_field.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Chào bạn đến TutorConnect!",
              style: AppTextStyles.headingBold.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 12),
            Text("Bạn là:",
                style: AppTextStyles.bodyText1.copyWith(fontSize: 20)),
            const SizedBox(height: 12),
            ProjectButton(
              title: "Gia sư",
              color: AppColors.colorButton,
              textColor: Colors.white,
              onPressed: () {},
            ),
            const SizedBox(height: 12),
            ProjectButton(
              title: "Học sinh",
              color: Colors.white,
              textColor: AppColors.primary,
              onPressed: () {},
            )
          ],
        ),
      )),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    bool rememberMe = false;
    return Scaffold(
        appBar: AppBar(
          title: Text('Đăng Nhập', style: AppTextStyles.headingMedium),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nhập số điện thoại:",
                style: AppTextStyles.bodyText1,
              ),
              const SizedBox(height: 8),
              PhoneTextField(
                controller: phoneController,
                onChanged: (value) => {},
              ),
              const SizedBox(height: 24),
              ProjectButton(
                title: "Đăng Nhập",
                color: AppColors.colorButton,
                textColor: Colors.white,
                onPressed: () {},
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
                                onTap: () {},
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
              const SizedBox(height: 12),
              SocialButton(
                title: "Facebook",
                iconPath: 'assets/icons/Facebook.svg',
                onPressed: () {},
              )
            ],
          ),
        ));
  }
}

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final int otpLength = 6;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  bool _isOtpValid = false;
  int _remainingTime = 60;
  bool _canResendOtp = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < otpLength; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(
      Duration(seconds: 1),
      () {
        if (!mounted) return;
        setState(() {
          _remainingTime--;
          if (_remainingTime > 0) {
            _startTimer();
          } else {
            _canResendOtp = true;
          }
        });
      },
    );
  }

  void _verifyOtp() {
    String otp = _controllers.map((controller) => controller.text).join();
    if (otp.length == otpLength) {
      setState(() {
        _isOtpValid = true;
      });
      Future.delayed(Duration(seconds: 2), () {
        if (!mounted) return;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xác Nhận OTP', style: AppTextStyles.headingMedium),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          RichText(
              text: TextSpan(
            text: "Nhập mã xác nhận đã gửi đến số điện thoại ",
            style: AppTextStyles.bodyText1.copyWith(color: AppColors.color600),
            children: [
              TextSpan(
                  text: "8927312461",
                  style: AppTextStyles.bodyText1
                      .copyWith(color: AppColors.colorButton))
            ],
          )),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
                otpLength,
                (index) => SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      style: AppTextStyles.bodyText1
                          .copyWith(color: AppColors.color500, fontSize: 24),
                      decoration: InputDecoration(
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppColors.color300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.colorButton, width: 2),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < otpLength - 1) {
                            _focusNodes[index + 1].requestFocus();
                          } else {
                            //_verifyOtp();
                            _focusNodes[index].unfocus();
                          }
                        } else if (index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ))),
          ),
          const SizedBox(height: 24),
          ProjectButton(
            title: "Xác Nhận",
            color: AppColors.colorButton,
            textColor: Colors.white,
            onPressed: () {},
          ),
          const SizedBox(height: 24),
          Center(
            child: RichText(
              text: TextSpan(
                  text: "Bạn chưa có nhận được code? ",
                  style: AppTextStyles.bodyText1
                      .copyWith(color: AppColors.color500),
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline, // Căn chỉnh theo baseline
                      baseline: TextBaseline.alphabetic,
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _canResendOtp = false;
                              _remainingTime = 60;
                              _startTimer();
                            });
                          },
                          child: Text(
                            "Gửi lại ",
                            style: AppTextStyles.bodyText1
                                .copyWith(color: AppColors.colorButton),
                          )),
                    ),
                    TextSpan(
                        text: "trong $_remainingTime giây",
                        style: AppTextStyles.bodyText1
                            .copyWith(color: AppColors.color500)),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}
