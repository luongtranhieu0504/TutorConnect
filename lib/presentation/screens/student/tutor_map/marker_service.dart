import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tutorconnect/data/models/users.dart';

import 'annotation_click_listenner.dart';

class MarkerService {
  final MapboxMap map;
  final BuildContext context;
  final Map<String, UserModel> _annotationTutorMap = {};

  PointAnnotationManager? _manager;

  MarkerService({required this.map, required this.context});

  Future<void> init() async {
    _manager = await map.annotations.createPointAnnotationManager();
    _manager?.addOnPointAnnotationClickListener(
      TutorAnnotationClickListener(context, _annotationTutorMap),
    );
  }


  Future<void> clear() async {
    await _manager?.deleteAll();
    _annotationTutorMap.clear();
  }

  Future<void> addMyLocationMarker(LatLng location, Uint8List imageBytes) async {
    final annotationOptions = PointAnnotationOptions(
      geometry: Point(coordinates: Position(location.longitude, location.latitude)),
      iconSize: 1.0,
      image: imageBytes,
      iconAnchor: IconAnchor.BOTTOM,
      textOffset: [0, 2],
    );
    await _manager?.create(annotationOptions);
  }

  Future<void> addTutorMarker({
    required LatLng location,
    required Uint8List imageBytes,
    required UserModel tutor,
  }) async {
    if (_manager == null) return;

    final annotationOptions = PointAnnotationOptions(
      geometry: Point(coordinates: Position(location.longitude, location.latitude)),
      iconSize: 1.0,
      image: imageBytes,
      iconAnchor: IconAnchor.BOTTOM,
      textOffset: [0, 2],
    );

    final annotation = await _manager!.create(annotationOptions);
    _annotationTutorMap[annotation.id] = tutor;

    debugPrint("✅ Added marker for tutor: ${tutor.name}, annotationId: ${annotation.id}");
  }

  UserModel? getTutorByAnnotationId(String id) => _annotationTutorMap[id];
}
