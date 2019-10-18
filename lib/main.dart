import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_app/blocs/location/location_bloc.dart';
import 'package:google_maps_app/maps_home.dart';
import 'package:location/location.dart';

void main() {
  runZoned(() => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        builder: (context) => LocationBloc(),
        child: MapsHome(),
      ),
    );
  }
}
