import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';

part 'location_event.dart';

part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  static LocationBloc of(BuildContext context) =>
      BlocProvider.of<LocationBloc>(context);

  LocationBloc() {
    hasLocationPermission.then((value) {
      if (value) {
        add(GetCurrentLocation());
      }
    });
  }

  @override
  LocationState get initialState => InitialLocationState();

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (event is GetCurrentLocation) {
      bool gotLocationPermission = await hasLocationPermission;
      if (!gotLocationPermission) {
        gotLocationPermission = await getLocationPermission();
      }
      if (gotLocationPermission) {
        LatLng currentLocation = await this.currentLocation;
        yield AuthorizedLocationState(currentLocation: currentLocation);
      }
    }
  }

  final Location _location = Location();

  Future<bool> get hasLocationPermission => _location.hasPermission();

  Future<bool> getLocationPermission() => _location.requestPermission();

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

  @override
  void onTransition(Transition<LocationEvent, LocationState> transition) {
    super.onTransition(transition);
  }
}
