import 'dart:math';

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


  double calculateDistanceInKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // bán kính trái đất (km)
    final dLat = degToRad(lat2 - lat1);
    final dLon = degToRad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degToRad(lat1)) * cos(degToRad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  double degToRad(double deg) => deg * pi / 180;


}