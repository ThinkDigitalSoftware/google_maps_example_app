import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_app/blocs/location/location_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsHome extends StatefulWidget {
  @override
  _MapsHomeState createState() => _MapsHomeState();
}

class _MapsHomeState extends State<MapsHome> {
  Completer<GoogleMapController> _controller = Completer();
  double cardsTopPosition = 0;
  double cardsBottomPosition;
  Direction dragDirection;

  bool showListView = true;

  Place currentPlace;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.map),
          title: Text("Google Maps Example"),
        ),
        body: Stack(
          children: <Widget>[
            BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if (state is! AuthorizedLocationState) {
                  return Card(
                    child: InkWell(
                      child: Center(
                        child: Text("Please enable location permissions"),
                      ),
                      onTap: () async =>
                          LocationBloc.of(context).add(GetCurrentLocation()),
                    ),
                  );
                } else {
                  LatLng currentLocation =
                      (state as AuthorizedLocationState).currentLocation;

                  return Card(
                    child: GoogleMap(
                      initialCameraPosition:
                          CameraPosition(target: currentLocation),
                      onMapCreated: (googleMapController) {
                        if (!_controller.isCompleted) {
                          _controller.complete(googleMapController);
                        }
                        googleMapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(target: currentLocation, zoom: 9),
                          ),
                        );
                      },
                      myLocationEnabled: true,
                      markers: places.map((place) => place.marker).toSet(),
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      onTap: (_) => setState(() => showListView = false),
                      onCameraMoveStarted: () {
                        if (showListView) {
                          setState(() => showListView = false);
                        }
                      },
                      onCameraIdle: () {
                        Future.delayed(Duration(seconds: 1)).then((_) {
                          setState(() => showListView = true);
                        });
                      },
                    ),
                  );
                }
              },
            ),
            AnimatedOpacity(
              opacity: showListView ? 1.0 : 0.3,
              child: Container(
                height: 150,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollStartNotification) {
                      if (!showListView) {
                        setState(() => showListView = true);
                      }
                    }
                    return null;
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: places.length,
                      itemBuilder: (context, index) => MapTile(
                        place: places.toList()[index],
                        onTap: (place) async {
                          if (!showListView) {
                            setState(() => showListView = true);
                          }
                          if (place != currentPlace) {
                            final mapsController = await _controller.future;
                            mapsController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: place.marker.position,
                                  zoom: 14,
                                ),
                              ),
                            );
                          }
                          currentPlace = place;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              duration: Duration(milliseconds: 100),
            )
          ],
        ),
      ),
    );
  }

  bool get cardIsAtTop => cardsTopPosition != null;
}

class MapTile extends StatelessWidget {
  final Place place;

  final Function(Place) onTap;

  const MapTile({Key key, @required this.place, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(10),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: place.image,
            fit: BoxFit.cover,
          ),
        ),
        width: 300,
        child: Container(
          height: 95,
          child: Material(
            color: Colors.black.withOpacity(0.5),
            child: ListTile(
              title: Text(
                place.marker.infoWindow.title,
                style: Theme.of(context).primaryTextTheme.title,
              ),
              subtitle: Text(
                place.address,
                style: Theme.of(context).primaryTextTheme.subtitle,
              ),
              onTap: () => onTap(place),
            ),
          ),
        ),
      ),
    );
  }
}

class Place {
  final Marker marker;
  final AssetImage image;
  final String address;

  Place({
    @required this.marker,
    @required this.image,
    @required this.address,
  });
}

Set<Place> places = {
  Place(
    marker: Marker(
      markerId: MarkerId('cabot'),
      position: LatLng(33.959138, -116.481751),
      infoWindow: InfoWindow(title: "Cabot's Pueblo Museum"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueCyan,
      ),
    ),
    image: AssetImage('assets/cabot.png'),
    address: "67616 Desert View Ave, Desert Hot Springs, CA 92240",
  ),
  Place(
    marker: Marker(
      markerId: MarkerId('agua_caliente'),
      position: LatLng(33.825829, -116.542732),
      infoWindow: InfoWindow(title: "Agua Caliente"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueAzure,
      ),
    ),
    image: AssetImage('assets/agua_caliente.png'),
    address: "401 E Amado Rd, Palm Springs, CA 92262",
  ),
  Place(
    marker: Marker(
      markerId: MarkerId('higher_grounds'),
      position: LatLng(33.745244, -116.713053),
      infoWindow: InfoWindow(title: "Higher Grounds Coffee House"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueOrange,
      ),
    ),
    image: AssetImage('assets/higher_grounds.png'),
    address: "54245 N Circle Dr, Idyllwild, CA 92549",
  ),
  Place(
    marker: Marker(
      markerId: MarkerId('la_casita'),
      position: LatLng(33.749180, -116.708569),
      infoWindow: InfoWindow(title: "La Casita"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueCyan,
      ),
    ),
    address: "54650 N Circle Dr, Idyllwild, CA 92549",
    image: AssetImage('assets/la_casita.png'),
  ),
  Place(
    marker: Marker(
      markerId: MarkerId('mountain_boho'),
      position: LatLng(33.746539, -116.710978),
      infoWindow: InfoWindow(title: "Mountain Boho"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRose,
      ),
    ),
    image: AssetImage('assets/mountain_boho.png'),
    address: "54425 North Circle Drive, Idyllwild, CA",
  ),
};

enum Direction { up, down, left, right }
