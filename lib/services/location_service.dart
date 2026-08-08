import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<bool> requestPermissions() async {
    return await Geolocator.requestPermission() == LocationPermission.always;
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }

  static Future<Position?> getLastKnownLocation() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (_) {
      return null;
    }
  }
}
