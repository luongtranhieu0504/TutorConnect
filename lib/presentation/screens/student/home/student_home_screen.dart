import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutorconnect/presentation/widgets/button_custom.dart';
import 'package:tutorconnect/presentation/widgets/search_text_field.dart';
import 'package:tutorconnect/theme/color_platte.dart';

import '../../../../theme/text_styles.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _HomeScreenState();
}

enum AppointmentStatus { pending, confirmed, completed }

class _HomeScreenState extends State<StudentHomeScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _uiContent();
  }

  Widget _uiContent() {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/icons/menu-2.svg')),
          actions: [
            IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/Notification.svg',
                  width: 50,
                  height: 50,
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchTextField(
                    controller: _searchController,
                    labelText: "Tìm kiếm",
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Môn Học",
                    style: AppTextStyles.headingMedium.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                      height: 110,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _subjectCard("Toán", "assets/icons/math.svg",
                              Colors.deepOrangeAccent, 10),
                          _subjectCard("Văn", "assets/icons/literature.svg",
                              Colors.lightBlueAccent, 10),
                          _subjectCard("Anh", "assets/icons/english.svg",
                              Colors.purpleAccent, 10),
                          _subjectCard("Lý", "assets/icons/physics.svg",
                              Colors.green, 10),
                          _subjectCard("Hóa", "assets/icons/biology.svg",
                              Colors.pinkAccent, 10),
                          _subjectCard("Tin Học", "assets/icons/computer.svg",
                              Colors.yellow, 10),
                        ],
                      )),
                  SizedBox(height: 20),
                  Text(
                    "Gia sư",
                    style: AppTextStyles.headingMedium.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                      height: 190,
                      child: ListView(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        children: [
                          _tutorCard(
                              "Luong Tran Hieu",
                              "Dạy từ cấp 1 - 3",
                              "Môn toán",
                              'assets/images/ML1.png',
                              "200.0",
                              '4.8',
                              200),
                          _tutorCard(
                              "Luong Tran Hieu",
                              "Dạy từ cấp 1 - 3",
                              "Môn toán",
                              'assets/images/ML1.png',
                              "200.0",
                              '4.8',
                              200),
                          _tutorCard(
                              "Luong Tran Hieu",
                              "Dạy từ cấp 1 - 3",
                              "Môn toán",
                              'assets/images/ML1.png',
                              "200.0",
                              '4.8',
                              200)
                        ],
                      )),
                  SizedBox(height: 20),
                  Text(
                    "Lịch học sắp tới",
                    style: AppTextStyles.headingMedium.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                      height: 190,
                      width: double.infinity,
                      child: ListView(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        children: [
                          _appointmentCard(
                            date: "Thứ Hai, 12 tháng 2",
                            time: "14:30 - 16:00",
                            tutorName: "Nguyễn Thị Hương",
                            subject: "Giáo viên Toán",
                            status: AppointmentStatus.pending,
                            avatarPath: 'assets/images/ML1.png',
                          ),
                          _appointmentCard(
                            date: "Thứ Hai, 12 tháng 2",
                            time: "14:30 - 16:00",
                            tutorName: "Nguyễn Thị Hương",
                            subject: "Giáo viên Toán",
                            status: AppointmentStatus.confirmed,
                            avatarPath: 'assets/images/ML1.png',
                          ),
                          _appointmentCard(
                            date: "Thứ Hai, 12 tháng 2",
                            time: "14:30 - 16:00",
                            tutorName: "Nguyễn Thị Hương",
                            subject: "Giáo viên Toán",
                            status: AppointmentStatus.completed,
                            avatarPath: 'assets/images/ML1.png',
                          )
                        ],
                      ))
                ],
              )),
        ));
  }

  Widget _subjectCard(
      String title, String iconPath, Color color, int tutorCount) {
    return Container(
      width: 159.0,
      margin: const EdgeInsets.only(right: 12.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(iconPath, width: 50, height: 50),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
                text: title,
                style: AppTextStyles.bodyText1.copyWith(color: Colors.white),
                children: [
                  TextSpan(
                    text: "- $tutorCount Tutors",
                    style:
                        AppTextStyles.bodyText1.copyWith(color: Colors.white70),
                  ),
                ]),
          )
        ],
      ),
    );
  }

  Widget _tutorCard(String name, String level, String subject,
      String avatarPath, String price, String rating, int numReviews) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 24,
            backgroundImage: AssetImage('assets/images/ML1.png'),
          ),
          SizedBox(width: 24),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              name,
              style: AppTextStyles.bodyText1.copyWith(color: Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              level,
              style: AppTextStyles.bodyText1.copyWith(color: Colors.black54),
            ),
            SizedBox(height: 4),
            Text(
              subject,
              style: AppTextStyles.bodyText1.copyWith(color: Colors.black54),
            ),
          ]),
        ]),
        SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              SizedBox(width: 4),
              Text(
                "$rating ($numReviews học sinh)",
                style: AppTextStyles.bodyText1
                    .copyWith(color: Colors.black, fontSize: 14),
              ),
            ],
          ),
          Text(
            "$price/buổi",
            style: AppTextStyles.bodyText1
                .copyWith(color: Colors.black, fontSize: 14),
          ),
        ]),
        SizedBox(height: 8),
        ProjectButton(
            title: "Xem thêm thông tin",
            color: AppColors.colorButton,
            textColor: Colors.white,
            onPressed: () {})
      ]),
    );
  }

  Widget _appointmentCard(
      {required String date,
      required String time,
      required String tutorName,
      required String subject,
      required AppointmentStatus status,
      required String avatarPath}) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(date,
                    style: AppTextStyles.bodyText1.copyWith(
                      color: AppColors.color600,
                      fontSize: 14,
                    )),
                Text(time,
                    style: AppTextStyles.bodyText1.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                    ))
              ]),
              _statusBadge(status)
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 24,
                backgroundImage: AssetImage(avatarPath),
              ),
              SizedBox(width: 8),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tutorName,
                    style: AppTextStyles.bodyText1.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                    )),
                Text(subject,
                    style: AppTextStyles.bodyText1.copyWith(
                      color: AppColors.color600,
                      fontSize: 14,
                    ))
              ])
            ],
          )
        ],
      ),
    );
  }

  Widget _statusBadge(AppointmentStatus status) {
    String badgeText;
    Color badgeColor;
    Color textColor;
    switch (status) {
      case AppointmentStatus.pending:
        badgeText = "Chờ xác nhận";
        badgeColor = Color(0xFFFEF9C3);
        textColor = Color(0xFFA16207);
        break;
      case AppointmentStatus.confirmed:
        badgeText = "Đã xác nhận";
        badgeColor = Color(0xFFDCFCE7);
        textColor = Color(0xFF15803D);
        break;
      case AppointmentStatus.completed:
        badgeText = "Đã hoàn thành";
        badgeColor = Color(0xFFF3F4F6);
        textColor = Color(0xFF4B5563);
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(badgeText,
          style: AppTextStyles.bodyText1.copyWith(
            color: textColor,
            fontSize: 12,
          )),
    );
  }
}
