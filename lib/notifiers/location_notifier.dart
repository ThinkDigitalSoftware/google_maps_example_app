import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationNotifier extends ChangeNotifier {
  final Location _location = Location();

  Future<bool> get hasLocationPermission => _location.hasPermission();

  Future<bool> getLocationPermission() async {
    bool permission;
    if (!await hasLocationPermission) {
      permission = await _location.requestPermission();
      notifyListeners();
    }
    return hasLocationPermission;
  }

  Future<LatLng> get currentLocation async {
    LocationData currentLocation;
    try {
      currentLocation = await _location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        return null;
      }
    }
    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }
}
