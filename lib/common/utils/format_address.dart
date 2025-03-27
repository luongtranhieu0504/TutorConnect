import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class AddressFormatter {
  Future<LatLng?> formatAddressToLatLng(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}