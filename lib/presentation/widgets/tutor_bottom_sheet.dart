import 'package:flutter/material.dart';

import '../../data/models/users.dart';
import '../../theme/text_styles.dart';

class TutorBottomSheet extends StatelessWidget {
  final UserModel tutor;
  const TutorBottomSheet({super.key, required this.tutor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ảnh đại diện
          // CircleAvatar(
          //   radius: 40,
          //   backgroundImage: AssetImage('assets/avatars/LM1.png'),
          // ),
          SizedBox(height: 12),
          // Tên
          Text(
            tutor.name ?? '',
            style: AppTextStyles(context).headingSemiBold.copyWith(fontSize: 20),
          ),
          SizedBox(height: 8),

          // Môn dạy
          Text(
            "📘 Môn: ${tutor.tutorProfile?.subjects.join(', ')}",
            style: AppTextStyles(context).bodyText2,
          ),

          // Giá dạy
          Text(
            "💰 Giá: ${tutor.tutorProfile?.pricePerHour}/buổi",
            style: AppTextStyles(context).bodyText2,
          ),

          // Đánh giá
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 4),
              Text("${tutor.tutorProfile?.rating} lượt đánh giá)"),
            ],
          ),
          SizedBox(height: 12),

          // Nút trao đổi
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // TODO: điều hướng đến màn trao đổi chat, hoặc show popup khác
            },
            icon: Icon(Icons.chat),
            label: Text("Trao đổi"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          )
        ],
      ),
    );;
  }
}
