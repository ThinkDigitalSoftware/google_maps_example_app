part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {}

class GetCurrentLocation extends LocationEvent {}
