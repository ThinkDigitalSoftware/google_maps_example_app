import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_app/notifiers/location_notifier.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapsHome extends StatefulWidget {
  @override
  _MapsHomeState createState() => _MapsHomeState();
}

class _MapsHomeState extends State<MapsHome> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng _currentLocation;
  bool hasLocationPermission = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Consumer<LocationNotifier>(
              builder: (context, locationNotifier, _) {
                return FutureBuilder<bool>(
                    future: locationNotifier.hasLocationPermission,
                    builder: (context, snapshot) {
                      if (snapshot.data != true) {
                        return Card(
                          margin: EdgeInsets.all(20),
                          child: InkWell(
                            child: Center(
                              child: Text("Please enable location permissions"),
                            ),
                            onTap: () async {
                              hasLocationPermission = await locationNotifier
                                  .getLocationPermission();
                              if (hasLocationPermission) {
                                _currentLocation =
                                    await locationNotifier.currentLocation;
                              }
                            },
                          ),
                        );
                      } else {
                        return FutureBuilder<LatLng>(
                            future: locationNotifier.currentLocation,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return GoogleMap(
                                  initialCameraPosition:
                                      CameraPosition(target: snapshot.data),
                                  onMapCreated: (googleMapController) {
                                    _controller.complete(googleMapController);
                                    googleMapController.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target: snapshot.data, zoom: 20),
                                      ),
                                    );
                                  },
                                  myLocationEnabled: true,
                                );
                              } else {
                                return LinearProgressIndicator();
                              }
                            });
                      }
                    });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("Title Text"),
                    subtitle: Text("Subtitle Text"),
                  );
                }),
          )
        ],
      ),
    );
  }
}
