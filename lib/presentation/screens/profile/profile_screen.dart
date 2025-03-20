import 'package:flutter/material.dart';
import 'package:tutorconnect/presentation/widgets/button_custom.dart';
import 'package:tutorconnect/theme/color_platte.dart';
import 'package:tutorconnect/theme/text_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return _uiContent();
  }

  Widget _uiContent() {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: _appBar(),
      ),
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _profileCard(Icons.history, "Lịch sử học tập", () {

                }
              ),
              _profileCard(Icons.favorite, "Gia sư yêu thích", () {

              }
              ),
              _profileCard(Icons.nights_stay_rounded, "Giao diện & Chủ đề", () {

              }
              ),
              _profileCard(Icons.feedback, "Lịch sử học tập", () {

              }
              ),
              ProjectButton(
                title: "Đăng xuất",
                color: AppColors.colorButton,
                textColor: Colors.white,
                onPressed: () {

                }
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 400,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
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
                backgroundImage: AssetImage('assets/images/ML1.png'),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nguyễn Văn A",
                    style: AppTextStyles.bodyText1.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                    )
                  ),
                  SizedBox(height: 5),
                  Text("nguyenvana@email.com",
                    style: AppTextStyles.bodyText2.copyWith(
                      color: AppColors.color600,
                      fontSize: 16,
                    )
                  ),
                  Text("0912345678",
                    style: AppTextStyles.bodyText2.copyWith(
                      color: AppColors.color600,
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
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.only(bottom: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
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
            Icon(icon, color: Colors.black),
            SizedBox(width: 10),
            Text(
              title,
              style: AppTextStyles.bodyText2.copyWith(
                color: Colors.black,
                fontSize: 16,
              )
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.black),
          ],
        )
      ),
    );
  }

}
