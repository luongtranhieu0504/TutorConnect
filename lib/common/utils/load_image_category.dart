import 'package:photo_manager/photo_manager.dart';

Future<List<AssetEntity>> loadImages() async {
  final PermissionState ps = await PhotoManager.requestPermissionExtend();
  if (!ps.hasAccess) {
    PhotoManager.openSetting(); // Gợi ý user mở permission
    return [];
  }

  final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
  final recent = albums.firstOrNull;
  if (recent == null) return [];

  return await recent.getAssetListRange(start: 0, end: 30);
}