import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tutorconnect/presentation/widgets/tutor_bottom_sheet.dart';

import '../../../../data/models/users.dart';

class TutorAnnotationClickListener extends OnPointAnnotationClickListener {
  final BuildContext context;
  final Map<String, UserModel> annotationTutorMap;

  TutorAnnotationClickListener(this.context, this.annotationTutorMap);

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    final tutor = annotationTutorMap[annotation.id];
    if (tutor != null) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => TutorBottomSheet(tutor: tutor),
      );
    }
  }
}
