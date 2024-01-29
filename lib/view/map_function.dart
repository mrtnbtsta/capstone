import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapFunctions {
  static final Location location = Location();
  static bool? serviceEnabled;
  static LatLng? currentPosition;
  static LocationData? locationData;

  static Future<void> getUserLocation() async {
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();

    if (serviceEnabled!) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled!) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.granted) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationData = await location.getLocation();
    currentPosition = LatLng(locationData!.latitude!, locationData!.longitude!);
  }
}
