import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/presentation/navigation/route_model.dart';

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
          GestureDetector(
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(tutor.photoUrl ?? ''),
            ),
            onTap: () {
              context.push(
                Routes.tutorProfilePage,
                extra: {
                  'tutor': tutor,
                  'isCurrentUser': false,
                },
              );
            },
          ),
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
              Text(
                "⭐ ${tutor.tutorProfile?.rating}",
                style: AppTextStyles(context).bodyText2,
              ),
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 4),
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
    );
  }
}
