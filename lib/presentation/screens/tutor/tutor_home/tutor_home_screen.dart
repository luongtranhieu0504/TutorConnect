import 'package:flutter/material.dart';
import 'package:tutorconnect/theme/color_platte.dart';
import 'package:tutorconnect/theme/text_styles.dart';

class TutorHomeScreen extends StatefulWidget {
  const TutorHomeScreen({super.key});

  @override
  State<TutorHomeScreen> createState() => _TutorHomeScreenState();
}

class _TutorHomeScreenState extends State<TutorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/ML1.png'),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Xin chào gia sư, Nguyễn Văn A',
                          style: AppTextStyles(context).headingMedium.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '⭐ 4.8 from 36 reviews',
                          style: AppTextStyles(context).bodyText2.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "Lịch dạy hôm nay",
                  style: AppTextStyles(context).headingSemiBold.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                // List of lessons
                _lessonCard("08:00 - 09:00", "Nguyễn Văn B", "Toán 12", "Trường THPT ABC"),
                _lessonCard("09:00 - 10:00", "Nguyễn Văn C", "Lý 12", "Trường THPT XYZ"),
                _lessonCard("10:00 - 11:00", "Nguyễn Văn D", "Hóa 12", "Trường THPT DEF"),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Handle "Xem thêm" tap
                    },
                    child: Text(
                      "Xem thêm",
                      style: AppTextStyles(context).bodyText2.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Yêu cầu từ học sinh",
                  style: AppTextStyles(context).headingSemiBold.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                // List of student requests
                _studentRequestCard("Nguyễn Văn E", "Toán 12", "Trường THPT GHI"),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Handle "Xem thêm" tap
                    },
                    child: Text(
                      "Xem thêm",
                      style: AppTextStyles(context).bodyText2.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Card(
                  color: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: Icon(Icons.person_outline, color: AppColors.primary),
                    title: Text(
                      'Complete your profile to attract more students',
                      style: AppTextStyles(context).bodyText2.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: AppColors.primary),
                      child: Text(
                        'Update Profile',
                        style: AppTextStyles(context).bodyText2.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
  Widget _lessonCard(String time, String student,String subject,String location) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          time,
          style: AppTextStyles(context).headingMedium.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student,
              style: AppTextStyles(context).bodyText2.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subject,
              style: AppTextStyles(context).bodyText2.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              location,
              style: AppTextStyles(context).bodyText2.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _studentRequestCard(String student, String subject, String location) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 8),
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/ML1.png'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student,
                    style: AppTextStyles(context).headingMedium.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subject,
                    style: AppTextStyles(context).bodyText2.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    location,
                    style: AppTextStyles(context).bodyText2.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Spacer(),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: AppColors.primary),
                ),
                child: Text(
                  "Nhắn tin",
                  style: AppTextStyles(context).bodyText2.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),

    );
  }
}
