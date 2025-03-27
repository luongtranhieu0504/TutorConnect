import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tutorconnect/common/utils/format_address.dart';
import 'package:tutorconnect/data/models/tutor.dart';
import 'package:tutorconnect/data/models/users.dart';
import 'package:tutorconnect/data/sample/tutor_profile_sample.dart';
import 'package:tutorconnect/presentation/widgets/search_text_field.dart';
import 'package:tutorconnect/theme/text_styles.dart';
import 'package:tutorconnect/theme/theme_ultils.dart';

import '../../../../common/utils/convert_widget_image.dart';
import '../../../../config/map_config.dart';
import 'annotation_click_listenner.dart';

class TutorMapScreen extends StatefulWidget {
  const TutorMapScreen({super.key});

  @override
  State<TutorMapScreen> createState() => _TutorMapScreenState();
}

class _TutorMapScreenState extends State<TutorMapScreen> {
  final TextEditingController _subjectController = TextEditingController();
  MapboxMap? mapboxMap;
  final Map<String, UserModel> _annotationTutorMap = {};

  // HCM center coordinates
  final Point _center = Point(coordinates: Position(106.660172, 10.762622));


  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(MapboxMap controller) {
    setState(() {
      mapboxMap = controller;
      _loadMarkers();
    });
  }


  Future<void> _loadMarkers() async {
    if (mapboxMap == null) return;
    final pointAnnotationManager = await mapboxMap!.annotations.createPointAnnotationManager();
    pointAnnotationManager.addOnPointAnnotationClickListener(
      TutorAnnotationClickListener(context, _annotationTutorMap),
    );
    for (var tutor in sampleTutorUsers) {
      final latLng =
          await AddressFormatter().formatAddressToLatLng(tutor.address ?? '');

      if (latLng != null) {
        final markerKey = GlobalKey();
        final markerWidget = RepaintBoundary(
            key: markerKey,
            child: _avatarMarker('assets/images/ML1.png', 60),
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
        await Future.delayed(Duration(milliseconds: 20));
        final imageBytes = await _renderMarkerToImage(markerKey, markerWidget);
        overlayEntry.remove();
        // Create a point annotation
        if (imageBytes != null) {
          final annotationOptions = PointAnnotationOptions(
            geometry: Point(
              coordinates: Position(latLng.longitude, latLng.latitude),
            ),
            iconSize: 1.0,
            image: imageBytes,
            iconAnchor: IconAnchor.BOTTOM,
            textOffset: [0, 2],
          );
          await pointAnnotationManager.create(annotationOptions);
          final annotation = await pointAnnotationManager.create(annotationOptions);
          _annotationTutorMap[annotation.id] = tutor;
        }
      }
    }
  }

  Future<Uint8List?> _renderMarkerToImage(
      GlobalKey markerKey, Widget markerWidget) async {
    final completer = Completer<Uint8List?>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final RenderRepaintBoundary boundary =
          markerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      completer.complete(byteData?.buffer.asUint8List());
    });

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm gia sư gần bạn'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MapWidget(
            key: ValueKey("mapWidget"),
            cameraOptions: CameraOptions(center: _center, zoom: 13.0),
            onMapCreated: _onMapCreated,
            onTapListener: (point) {
            },

          ),
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Row(children: [
              Expanded(
                child: SearchTextField(
                  controller: _subjectController,
                  labelText: 'Nhập môn học',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  icon: themedIcon(Icons.location_on, context),
                  label: Text(
                    "Lọc theo vị trí",
                    style: AppTextStyles(context).bodyText2.copyWith(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  Widget _avatarMarker(String avatarUrl, double size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Khung pin
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.teal,
            border: Border.all(color: Colors.white, width: 4),
          ),
        ),
        // Avatar bo tròn
        Container(
          width: size - 10,
          height: size - 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(avatarUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Mũi tên chỉ xuống
        Positioned(
          bottom: -size * 0.12,
          child: Transform.rotate(
            angle: 0.785, // 45 độ
            child: Container(
              width: size * 0.2,
              height: size * 0.2,
              color: Colors.teal,
            ),
          ),
        )
      ],
    );
  }


}
