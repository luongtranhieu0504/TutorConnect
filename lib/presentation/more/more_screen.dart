// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../../di/di.dart';
// import '../../theme/color_platte.dart';
// import '../../theme/text_styles.dart';
// import '../extensions/naviagtion_service.dart';
// import '../screens/login/login_bloc.dart';
// import '../widgets/button_custom.dart';
//
// class OtpVerificationScreen extends StatefulWidget {
//   final String verificationId;
//   final String phone;
//   const OtpVerificationScreen({super.key, required this.verificationId, required this.phone});
//
//   @override
//   State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
// }
//
// class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//   final int otpLength = 6;
//   final List<TextEditingController> _controllers = [];
//   final List<FocusNode> _focusNodes = [];
//   final _bloc = getIt<LoginBloc>();
//   int _remainingTime = 60;
//
//   @override
//   void initState() {
//     super.initState();
//     _bloc.verifyOtpBroadcast.listen((state) {
//       state.when(
//         loading: () {
//         },
//         success: (data) {
//           NavigationService.navigateAndReplace('/main');
//         },
//         failure: (message) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(message)),
//           );
//         },
//       );
//     });
//
//     /// Lắng nghe trạng thái gửi lại OTP từ Bloc
//     _bloc.signInBroadcast.listen((state) {
//     });
//   }
//
//   void _startTimer() {
//     Future.delayed(
//       Duration(seconds: 1),
//           () {
//         if (!mounted) return;
//         setState(() {
//           _remainingTime--;
//           if (_remainingTime > 0) {
//             _startTimer();
//           } else {
//           }
//         });
//       },
//     );
//   }
//
//   void _verifyOtp() {
//     String otp = _controllers.map((controller) => controller.text).join();
//     if (otp.length == otpLength) {
//       setState(() {
//         _bloc.verifyOtp(otp);
//       });
//       Future.delayed(Duration(seconds: 2), () {
//         if (!mounted) return;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var focusNode in _focusNodes) {
//       focusNode.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Xác Nhận OTP', style: AppTextStyles.headingMedium),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
//           RichText(
//               text: TextSpan(
//                 text: "Nhập mã xác nhận đã gửi đến số điện thoại ",
//                 style: AppTextStyles.bodyText1.copyWith(color: AppColors.color600),
//                 children: [
//                   TextSpan(
//                       text: "8927312461",
//                       style: AppTextStyles.bodyText1
//                           .copyWith(color: AppColors.colorButton))
//                 ],
//               )),
//           const SizedBox(height: 24),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: List.generate(
//                 otpLength,
//                     (index) => SizedBox(
//                     width: 50,
//                     child: TextField(
//                       controller: _controllers[index],
//                       focusNode: _focusNodes[index],
//                       textAlign: TextAlign.center,
//                       keyboardType: TextInputType.number,
//                       maxLines: 1,
//                       style: AppTextStyles.bodyText1
//                           .copyWith(color: AppColors.color500, fontSize: 24),
//                       decoration: InputDecoration(
//                         counterText: '',
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: AppColors.color300),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(
//                               color: AppColors.colorButton, width: 2),
//                         ),
//                       ),
//                       inputFormatters: [
//                         FilteringTextInputFormatter.digitsOnly,
//                       ],
//                       onChanged: (value) {
//                         if (value.isNotEmpty) {
//                           if (index < otpLength - 1) {
//                             _focusNodes[index + 1].requestFocus();
//                           } else {
//                             //_verifyOtp();
//                             _focusNodes[index].unfocus();
//                           }
//                         } else if (index > 0) {
//                           _focusNodes[index - 1].requestFocus();
//                         }
//                       },
//                     ))),
//           ),
//           const SizedBox(height: 24),
//           ProjectButton(
//             title: "Xác Nhận",
//             color: AppColors.colorButton,
//             textColor: Colors.white,
//             onPressed: () => _verifyOtp(),
//           ),
//           const SizedBox(height: 24),
//           Center(
//             child: RichText(
//               text: TextSpan(
//                   text: "Bạn chưa có nhận được code? ",
//                   style: AppTextStyles.bodyText1
//                       .copyWith(color: AppColors.color500),
//                   children: [
//                     WidgetSpan(
//                       alignment: PlaceholderAlignment.baseline, // Căn chỉnh theo baseline
//                       baseline: TextBaseline.alphabetic,
//                       child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _remainingTime = 60;
//                               _startTimer();
//                             });
//                           },
//                           child: Text(
//                             "Gửi lại ",
//                             style: AppTextStyles.bodyText1
//                                 .copyWith(color: AppColors.colorButton),
//                           )),
//                     ),
//                     TextSpan(
//                         text: "trong $_remainingTime giây",
//                         style: AppTextStyles.bodyText1
//                             .copyWith(color: AppColors.color500)),
//                   ]),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }