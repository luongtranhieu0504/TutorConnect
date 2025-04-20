import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tutorconnect/data/models/users.dart';
import 'package:tutorconnect/presentation/navigation/route_model.dart';
import 'package:tutorconnect/presentation/widgets/button_custom.dart';
import 'package:tutorconnect/theme/color_platte.dart';
import 'package:tutorconnect/theme/text_styles.dart';
import 'package:tutorconnect/theme/theme_provider.dart';
import 'package:tutorconnect/theme/theme_ultils.dart';

import '../../../di/di.dart';
import '../login/login_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _bloc = getIt<LoginBloc>();
  Color selectedColor = AppColors.primary;




  @override
  Widget build(BuildContext context) {
    return _uiContent(context);
  }

  Widget _uiContent(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: _appBar(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _profileCard(Icons.history, "Lịch sử học tập", () {
                  context.push(Routes.historySessionPage);
                }
              ),
              _profileCard(Icons.favorite, "Gia sư yêu thích", () {

              }
              ),
              _profileCard(Icons.nights_stay_rounded, "Giao diện & Chủ đề", () => _showThemeDialog(context)),
              _profileCard(Icons.feedback, "Phản hồi với chúng tôi", () {

              }
              ),
              ProjectButton(
                title: "Đăng xuất",
                color: AppColors.colorButton,
                textColor: Colors.white,
                onPressed: () {
                  _bloc.logout();
                }
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 400,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Đổ bóng nhẹ để tách biệt
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/images/ML1.png"),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Luong Tran Hiue",
                    style: AppTextStyles(context).bodyText1.copyWith(
                      fontSize: 20,
                    )
                  ),
                  SizedBox(height: 5),
                  Text("luongtranhieu2@gmail.com",
                    style: AppTextStyles(context).bodyText2.copyWith(
                      fontSize: 16,
                    )
                  ),
                  Text("Học sinh",
                    style: AppTextStyles(context).bodyText2.copyWith(
                      fontSize: 16,
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _profileCard(IconData icon, String title, VoidCallback onPressed) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Đổ bóng nhẹ để tách biệt
              spreadRadius: 2,
              blurRadius: 5,
            )
          ]
        ),
        child: Row(
          children: [
            themedIcon(icon, context),
            SizedBox(width: 10),
            Text(
              title,
              style: AppTextStyles(context).bodyText2.copyWith(
                fontSize: 16,
              )
            ),
            Spacer(),
            themedIcon(Icons.arrow_forward_ios, context),
          ],
        )
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final themeProvider = Provider.of<ThemeProvider>(context); // 👈 listen: true để rebuild
            final isDark = themeProvider.themeMode == ThemeMode.dark;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Chế độ sáng
                  ListTile(
                    leading: Text("🌞"),
                    title: Text("Chế độ sáng"),
                    trailing: Radio(
                      value: false,
                      groupValue: isDark,
                      onChanged: (value) {
                        themeProvider.toggleTheme(false);
                      },
                    ),
                  ),
                  // Chế độ tối
                  ListTile(
                    leading: Text("🌙"),
                    title: Text("Chế độ tối"),
                    trailing: Radio(
                      value: true,
                      groupValue: isDark,
                      onChanged: (value) {
                        themeProvider.toggleTheme(true);
                      },
                    ),
                  ),
                  Divider(),
                  // Màu chủ đề
                  ListTile(
                    leading: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    title: Text("Màu chủ đề:"),
                  ),

                  // Chọn màu chủ đề
                  Wrap(
                    spacing: 10,
                    children: [
                      _colorButton(Colors.blue, "Xanh dương"),
                      _colorButton(Colors.green, "Xanh lá"),
                      _colorButton(Colors.purple.shade200, "Tím nhạt"),
                    ],
                  ),

                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                    ),
                    child: Text("Đóng"),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  // Widget nút chọn màu
  Widget _colorButton(Color color, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
        context.pop();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedColor == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(label, style: TextStyle(color: Colors.black)),
      ),
    );
  }

}
