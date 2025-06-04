import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tutorconnect/domain/model/tutor.dart';
import 'package:tutorconnect/presentation/widgets/tutor_bottom_sheet.dart';
import '../../../../domain/model/user.dart';

class TutorAnnotationClickListener extends OnPointAnnotationClickListener {
  final BuildContext context;
  final Map<String, Tutor> annotationTutorMap;

  TutorAnnotationClickListener(this.context, this.annotationTutorMap);
  @override
  bool onPointAnnotationClick(PointAnnotation annotation) {
    final tutor = annotationTutorMap[annotation.id];
    if (tutor != null) {
      _showBottomSheet(tutor);
      // showBottomSheet or do whatever
    } else {
      print("⚠️ Unknown annotation clicked: ${annotation.id}");
    }
    return true;
  }
  void _showBottomSheet(Tutor tutor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return TutorBottomSheet(tutor: tutor);
      },
    );
  }
}
