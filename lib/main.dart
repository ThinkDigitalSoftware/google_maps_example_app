import 'package:flutter/material.dart';
import 'package:google_maps_app/maps_home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapsHome(),
    );
  }
}
