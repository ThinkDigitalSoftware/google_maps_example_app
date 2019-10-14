import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_app/maps_home.dart';
import 'package:google_maps_app/notifiers/location_notifier.dart';
import 'package:provider/provider.dart';

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
      home: ChangeNotifierProvider(
        builder: (context) => LocationNotifier(),
        child: MapsHome(),
      ),
    );
  }
}
