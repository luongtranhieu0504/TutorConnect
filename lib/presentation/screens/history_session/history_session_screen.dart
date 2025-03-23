import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tutorconnect/common/utils/format_utils.dart';
import 'package:tutorconnect/data/models/session.dart';
import 'package:tutorconnect/presentation/widgets/button_custom.dart';
import 'package:tutorconnect/theme/color_platte.dart';
import 'package:tutorconnect/theme/text_styles.dart';

import '../../../common/utils/number_formatter.dart';

class HistorySessionScreen extends StatefulWidget {
  const HistorySessionScreen({super.key});

  @override
  State<HistorySessionScreen> createState() => _HistorySessionScreenState();
}

class _HistorySessionScreenState extends State<HistorySessionScreen> {
  final List<SessionModel> sessions = [
    SessionModel(
      id: "s001",
      studentId: "u123",
      tutorId: "hieu",
      subject: "Toán",
      datetime: DateTime(2025, 3, 12, 15, 0),
      durationMinutes: 120,
      location: "Q.10",
      status: "completed",
      tuition: 100000.0,
      studentRating: 4,
      studentFeedback: "Thầy dạy dễ hiểu!",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _uiContent();
  }

  Widget _uiContent() {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lịch sử học tập', style: AppTextStyles(context).headingMedium),
        ),
        body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Lọc theo thời gian",
                      style: AppTextStyles(context).bodyText1
                          .copyWith(fontSize: 16)),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text("1 tháng qua",
                        style: AppTextStyles(context).bodyText1
                            .copyWith(fontSize: 16)),
                  )
                ],
              ),
              SizedBox(height: 24),
              Expanded(
                  child: ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      return _sessionCard(sessions[index], () {});
                    }
                  )
              )
            ]
            )
        )
    );
  }

  Widget _sessionCard(SessionModel session, VoidCallback onPressed) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: EdgeInsets.all(17.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.book),
            SizedBox(width: 8),
            Text(
              "Môn học: ",
              style: AppTextStyles(context).bodyText2
                  .copyWith(fontSize: 14),
            ),
            Text(session.subject,
                style: AppTextStyles(context).bodyText1
                    .copyWith(fontSize: 14))
          ]),
          SizedBox(height: 12),
          Row(children: [
            Icon(Icons.person),
            SizedBox(width: 8),
            Text(
              "Gia sư: ",
              style: AppTextStyles(context).bodyText2
                  .copyWith(fontSize: 14),
            ),
            Text(session.tutorId,
                style: AppTextStyles(context).bodyText1
                    .copyWith(fontSize: 14))
          ]),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Icon(Icons.date_range),
                SizedBox(width: 8),
                Text(
                  "Ngày: ",
                  style: AppTextStyles(context).bodyText2
                      .copyWith(fontSize: 14),
                ),
                Text(FormatUtils.formatDate(session.datetime),
                    style: AppTextStyles(context).bodyText1
                        .copyWith(fontSize: 14))
              ]),
              Row(children: [
                Icon(Icons.access_time),
                SizedBox(width: 8),
                Text(FormatUtils.formatTimeRange(session.datetime, session.durationMinutes),
                    style: AppTextStyles(context).bodyText1
                        .copyWith(fontSize: 14))
              ]),
            ]
          ),
          SizedBox(height: 12),
          Row(children: [
            Icon(Icons.location_city),
            SizedBox(width: 8),
            Text(
              "Địa chỉ: ",
              style: AppTextStyles(context).bodyText1
                  .copyWith(fontSize: 14),
            ),
            Text(session.location,
                style: AppTextStyles(context).bodyText1
                    .copyWith(fontSize: 14))
          ]),
          SizedBox(height: 12),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Icon(Icons.monetization_on),
                  SizedBox(width: 8),
                  Text(
                    "Học phí: ",
                    style: AppTextStyles(context).bodyText1
                        .copyWith(color: AppColors.color500, fontSize: 14),
                  ),
                  Text("${NumberFormatter.formatCurrency(session.tuition)} VND",
                      style: AppTextStyles(context).bodyText1
                          .copyWith(fontSize: 14))
                ]),
                Row(children: [
                  Icon(Icons.star),
                  SizedBox(width: 8),
                  Text(session.studentRating.toString(),
                      style: AppTextStyles(context).bodyText1
                          .copyWith(fontSize: 14))
                ]),
              ]
          ),
          SizedBox(height: 12),
          ProjectButton(
              title: "Đánh giá lại",
              color: AppColors.primary,
              textColor: Colors.white,
              onPressed: onPressed
          )
        ]
        )
    );
  }
}
