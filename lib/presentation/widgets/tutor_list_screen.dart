import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorconnect/domain/model/tutor.dart';
import 'package:tutorconnect/theme/text_styles.dart';

import '../navigation/route_model.dart';

class TutorListScreen extends StatelessWidget {
  final List<Tutor> tutors;

  const TutorListScreen({super.key, required this.tutors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách gia sư", style: AppTextStyles(context).headingMedium),
      ),
      body: ListView.builder(
        itemCount: tutors.length,
        itemBuilder: (context, index) {
          final tutor = tutors[index];
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(tutor.user.photoUrl ?? ''),
              ),
              title: Text(tutor.user.name ?? '', style: AppTextStyles(context).bodyText1),
              subtitle: Text(tutor.subjects.toString(), style: AppTextStyles(context).bodyText2),
              trailing: ElevatedButton(
                onPressed: () {
                  context.push(
                  Routes.tutorProfilePage,
                    extra: {
                      'tutor': tutor,
                      'isCurrentUser' : false,
                    },
                  );
                },
                child: Text("Xem hồ sơ"),
              ),
            ),
          );
        },
      ),
    );
  }
}