import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/data/models/users.dart';
import 'package:tutorconnect/presentation/navigation/route_model.dart';
import 'package:tutorconnect/presentation/screens/student/home/student_home_bloc.dart';
import 'package:tutorconnect/presentation/screens/student/home/student_home_state.dart';
import 'package:tutorconnect/presentation/widgets/button_custom.dart';
import 'package:tutorconnect/presentation/widgets/search_text_field.dart';
import 'package:tutorconnect/theme/color_platte.dart';
import 'package:tutorconnect/theme/theme_ultils.dart';

import '../../../../di/di.dart';
import '../../../../theme/text_styles.dart';

class StudentHomeScreen extends StatefulWidget {
  final String uid;
  const StudentHomeScreen({super.key, required this.uid});

  @override
  State<StudentHomeScreen> createState() => _HomeScreenState();
}

enum AppointmentStatus { pending, confirmed, completed }

class _HomeScreenState extends State<StudentHomeScreen> {
  final _bloc = getIt<StudentHomeBloc>();
  final _searchController = TextEditingController();

  @override
  initState() {
    super.initState();
    _bloc.getData(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StudentHomeBloc, StudentHomeState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserSuccess) {
            final user = (state).user;
            return _uiContent(user);
          } else if (state is UserFailure) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text("Unknown state"));
        },
        bloc: _bloc,
      ),
    );
  }

  Widget _uiContent(UserModel user) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(double.infinity, 100), 
            child: _appBar(user),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push(
                        Routes.tutorMapPage,
                        extra: user
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.withOpacity(0.7)),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          themedIcon(Icons.search, context),
                          SizedBox(width: 8),
                          Text(
                            "Tìm kiếm gia sư",
                            style: AppTextStyles(context).bodyText1.copyWith(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          )
                        ],
                      )
                    )
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Môn Học",
                    style: AppTextStyles(context).headingMedium.copyWith(
                        fontSize: 24,
                    ),
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
                    style: AppTextStyles(context).headingMedium.copyWith(
                        fontSize: 24,
                    ),
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
                    style: AppTextStyles(context).headingMedium.copyWith(
                        fontSize: 24,
                        ),
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
  
  Widget _appBar(UserModel user) {
    return SafeArea(
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(user.photoUrl ?? ''),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Xin chào học sinh !',
                        style: AppTextStyles(context).headingSemiBold.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        user.name ?? '',
                        style: AppTextStyles(context).headingMedium.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  // Handle notification button press
                },
              )
            ],
          ),
        ),
      )
    );
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
                style: AppTextStyles(context).bodyText1.copyWith(color: Colors.white),
                children: [
                  TextSpan(
                    text: "- $tutorCount Tutors",
                    style:
                        AppTextStyles(context).bodyText1.copyWith(color: Colors.white70),
                  ),
                ]),
          )
        ],
      ),
    );
  }

  Widget _tutorCard(String name, String level, String subject,
      String avatarPath, String price, String rating, int numReviews) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: isDarkMode
              ? Theme.of(context).colorScheme.surface.withOpacity(0.85)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.08) // tạo border nhẹ cho dark mode
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3) // bóng nhẹ dark mode
                  : Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ]
      ),
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
              style: AppTextStyles(context).bodyText1,
            ),
            SizedBox(height: 4),
            Text(
              level,
              style: AppTextStyles(context).bodyText2.copyWith(fontSize: 15),
            ),
            SizedBox(height: 4),
            Text(
              subject,
              style: AppTextStyles(context).bodyText2.copyWith(fontSize: 15),
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
                style: AppTextStyles(context).bodyText1
                    .copyWith(fontSize: 14),
              ),
            ],
          ),
          Text(
            "$price/buổi",
            style: AppTextStyles(context).bodyText1
                .copyWith(fontSize: 14),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: isDarkMode
              ? Theme.of(context).colorScheme.surface.withOpacity(0.85)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode
                ? Colors.white.withOpacity(0.08) // tạo border nhẹ cho dark mode
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3) // bóng nhẹ dark mode
                  : Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(date,
                    style: AppTextStyles(context).bodyText2.copyWith(
                      fontSize: 14,
                    )),
                Text(time,
                    style: AppTextStyles(context).bodyText1.copyWith(
                      fontSize: 14,
                    ))
              ]),
              SizedBox(width: 8),
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
                    style: AppTextStyles(context).bodyText1.copyWith(
                      fontSize: 14,
                    )),
                Text(subject,
                    style: AppTextStyles(context).bodyText2.copyWith(
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
          style: AppTextStyles(context).bodyText1.copyWith(
            color: textColor,
            fontSize: 12,
          )),
    );
  }
}
