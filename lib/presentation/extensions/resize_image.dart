import 'package:flutter/services.dart';

Future<Uint8List> resizeImage() async {
  final ByteData data = await rootBundle.load('assets/images/ML1.png');
  final Uint8List bytes = data.buffer.asUint8List();
  return bytes; // Ở đây có thể dùng thư viện `image` để resize nếu cần
}