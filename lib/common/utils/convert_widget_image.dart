import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// Future<Uint8List?> renderMarkerToImage(
//     GlobalKey markerKey,
//     Widget markerWidget,
//     String imageUrl, // ✅ Truyền thêm URL ảnh để chờ load xong
//     ) async {
//   final completer = Completer<Uint8List?>();
//
//   // 1. Đảm bảo ảnh được tải xong từ mạng
//   final ImageProvider imageProvider = NetworkImage(imageUrl);
//   final ImageStream stream = imageProvider.resolve(const ImageConfiguration());
//   final imageLoadCompleter = Completer<void>();
//
//   final listener = ImageStreamListener(
//         (ImageInfo _, bool __) {
//       imageLoadCompleter.complete();
//     },
//     onError: (dynamic error, StackTrace? stackTrace) {
//       debugPrint("❌ Failed to load marker image: $error");
//       imageLoadCompleter.complete(); // tránh deadlock
//     },
//   );
//
//   stream.addListener(listener);
//   await imageLoadCompleter.future;
//   stream.removeListener(listener);
//
//   // 2. Chờ frame UI dựng xong
//   WidgetsBinding.instance.addPostFrameCallback((_) async {
//     try {
//       final RenderRepaintBoundary boundary =
//       markerKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//
//       final image = await boundary.toImage(pixelRatio: 3.0);
//       final byteData = await image.toByteData(format: ImageByteFormat.png);
//       completer.complete(byteData?.buffer.asUint8List());
//     } catch (e) {
//       debugPrint("❌ Error rendering marker to image: $e");
//       completer.complete(null);
//     }
//   });
//
//   return completer.future;
// }

Future<Uint8List?> renderMarkerToImage(
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





