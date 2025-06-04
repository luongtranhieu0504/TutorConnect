import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tutorconnect/common/utils/format_address.dart';
import 'package:tutorconnect/data/manager/account.dart';
import 'package:tutorconnect/di/di.dart';
import 'package:tutorconnect/presentation/screens/student/tutor_map/tutor_map_bloc.dart';
import 'package:tutorconnect/presentation/screens/student/tutor_map/tutor_map_state.dart';

import '../../../../common/utils/convert_widget_image.dart';
import '../../../../domain/model/tutor.dart';
import 'marker_service.dart';

class TutorMapScreen extends StatefulWidget {

  const TutorMapScreen({super.key});

  @override
  State<TutorMapScreen> createState() => _TutorMapScreenState();
}

class _TutorMapScreenState extends State<TutorMapScreen> {
  final _bloc = getIt<TutorMapBloc>();
  final student = Account.instance.user;
  late double selectedDistanceInKm = 7.0;
  late String selectedSubject = 'Tất cả';
  MapboxMap? mapboxMap;
  late final Point _center;
  late final MarkerService markerService;
  final List<String> subjects = ["Tất cả", "Toán", "Văn", "Anh", "Lý", "Hóa", "Tin Học"];


  @override
  void initState() {
    super.initState();
    _bloc.getTutors();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TutorMapBloc, TutorMapState>(
      builder: (context, state) {
        if (state is TutorMapLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TutorMapFailure) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is TutorMapSuccess) {
          final tutors = state.tutors;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadMarkers(tutors, subject: selectedSubject != "Tất cả" ? selectedSubject : null, distance: selectedDistanceInKm);
          });
          return _buildContent(tutors);
        }
        return Container();
      },
      bloc: _bloc,
    );
  }

  Widget _buildContent(List<Tutor> tutors) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm gia sư gần bạn'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MapWidget(
            key: ValueKey("mapWidget"),
            onMapCreated: _onMapCreated,
            onTapListener: (point) {},
          ),
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey.withOpacity(0.7)),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: DropdownButton<String>(
                  value: selectedSubject,
                  items: subjects
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
                      .toList(),
                  onChanged: (value) async {
                    setState(() {
                      selectedSubject = value!;
                    });
                  },
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey.withOpacity(0.7)),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: DropdownButton<double>(
                  value: selectedDistanceInKm,
                  items: [7.0, 10.0, 15.0, 20.0]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text("Trong vòng $e km"),
                          ))
                      .toList(),
                  onChanged: (value) async {
                    setState(() {
                      selectedDistanceInKm = value!;
                    });
                  },
                )
              ),
            ]),
          )
        ],
      ),
    );
  }

  void _onMapCreated(MapboxMap controller) async {
    mapboxMap = controller;
    markerService = MarkerService(map: controller, context: context);
    await markerService.init();


    final myAddress = student.address;
    if (myAddress != null) {
      final latLng = await AddressFormatter().formatAddressToLatLng(myAddress);
      if (latLng != null) {
        setState(() {
          _center =
              Point(coordinates: Position(latLng.longitude, latLng.latitude));
        });
        // Move the map camera to the new center
        mapboxMap?.flyTo(
          CameraOptions(
            center: _center,
            zoom: 11.0,
          ),
          MapAnimationOptions(
            duration: 2000,
          ),
        );
        // Draw the radius circle
      }
    }
  }


  Future<void> _loadMarkers(List<Tutor> tutors, {String? subject, required double distance}) async {
    if (mapboxMap == null) return;
    await markerService.clear();

    final myAddress = student.address;
    final myLatLng = await AddressFormatter().formatAddressToLatLng(myAddress!);

    // 👉 Thêm marker của học sinh
    final myMarkerBytes = await _renderMarkerWidget(student.photoUrl ?? '', size: 60);
    if (myMarkerBytes != null) {
      await markerService.addMyLocationMarker(myLatLng!, myMarkerBytes);
    }

    for (var tutor in tutors) {
      final latLng = await AddressFormatter().formatAddressToLatLng(tutor.user.address ?? '');
      if (latLng == null || myLatLng == null) continue;

      final distanceInKm = AddressFormatter().calculateDistanceInKm(
        myLatLng.latitude,
        myLatLng.longitude,
        latLng.latitude,
        latLng.longitude,
      );

      final hasSubject = subject != null && subject.isNotEmpty;
      final matchSubject = tutor.subjects.contains(subject);
      final matchDistance = distanceInKm <= distance;

      if (hasSubject) {
        if (!matchSubject || !matchDistance) continue;
      } else {
        if (!matchDistance) continue;
      }
      final imageBytes = await _renderMarkerWidget(tutor.user.photoUrl!, size: 60);
      if (imageBytes != null) {
        await markerService.addTutorMarker(
          location: latLng,
          imageBytes: imageBytes,
          tutor: tutor,
        );
      }
    }
  }


  Widget _avatarMarker(String avatarUrl, double size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Circular background
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.teal,
            border: Border.all(color: Colors.white, width: 4),
          ),
        ),
        // Avatar with error handling
        ClipOval(
          child: Image.network(
            avatarUrl,
            width: size - 10,
            height: size - 10,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback widget in case of error
              return Container(
                width: size - 10,
                height: size - 10,
                color: Colors.grey,
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                  size: size / 2,
                ),
              );
            },
          ),
        ),
        // Downward arrow
        Positioned(
          bottom: -size * 0.12,
          child: Transform.rotate(
            angle: 0.785, // 45 degrees
            child: Container(
              width: size * 0.2,
              height: size * 0.2,
              color: Colors.teal,
            ),
          ),
        ),
      ],
    );
  }

  Future<Uint8List?> _renderMarkerWidget(String imageAssetOrUrl, {double size = 60}) async {
    final markerKey = GlobalKey();
    final markerWidget = RepaintBoundary(
      key: markerKey,
      child: _avatarMarker(imageAssetOrUrl, size),
    );

    final overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        top: -9999,
        left: -9999,
        child: Material(
          type: MaterialType.transparency,
          child: markerWidget,
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    await Future.delayed(const Duration(milliseconds: 20));

    final bytes = await renderMarkerToImage(markerKey, markerWidget);
    overlayEntry.remove();
    return bytes;
  }


}
