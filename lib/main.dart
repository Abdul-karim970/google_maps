import 'package:flutter/material.dart';
import 'google_map_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GoogleMapWidget(),
    );
  }
}



// Google Maps Links
  // Initializing Getting Starting(Official Explanations)
     // https://developers.google.com/maps/documentation/android-sdk/config
     
  // Basics of google maps
     // https://medium.com/flutter/google-maps-and-flutter-cfb330f9a245

  // Google map Live location
    //  https://medium.com/flutter-community/flutter-google-map-with-live-location-tracking-uber-style-12da38771829