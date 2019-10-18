part of 'location_bloc.dart';

@immutable
abstract class LocationState {
  final bool hasLocationPermissions;

  LocationState({this.hasLocationPermissions});
}

class InitialLocationState extends LocationState {
  InitialLocationState() : super(hasLocationPermissions: false);
}

class AuthorizedLocationState extends LocationState {
  final LatLng currentLocation;

  AuthorizedLocationState({this.currentLocation})
      : super(hasLocationPermissions: true);
}
