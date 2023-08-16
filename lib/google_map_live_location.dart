import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapLiveLocation extends StatefulWidget {
  const GoogleMapLiveLocation({super.key});

  @override
  State<GoogleMapLiveLocation> createState() => _GoogleMapLiveLocationState();
}

class _GoogleMapLiveLocationState extends State<GoogleMapLiveLocation> {
  var homeLocation = const LatLng(29.394859, 71.704117);
  var casLocation = const LatLng(29.382932, 71.715578);
  Completer<GoogleMapController> mapController = Completer();
  LocationData? currentLocation;
  BitmapDescriptor homeMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor casMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentMarker = BitmapDescriptor.defaultMarker;

  List<LatLng> polylineCoordinates = [];
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDqLtNRd6OBjjYDl1nDCuaPBDP9Cy3GgAk',
      PointLatLng(homeLocation.latitude, homeLocation.longitude),
      PointLatLng(casLocation.latitude, casLocation.longitude),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      if (mounted) {
        // print(
        //     'lllllllllleeeeeeeeeennnnnnnnnngght${polylineCoordinates.length}');
        setState(() {});
      }
    }
  }

  void getCurrentLocation() async {
    Location location = Location();

    location
        .getLocation()
        .then((locationData) => currentLocation = locationData);

    location.onLocationChanged.listen((locationData) async {
      currentLocation = locationData;
      GoogleMapController controller = await mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          zoom: 16,
          target: LatLng(locationData.latitude!, locationData.longitude!))));

      if (mounted) {
        setState(() {});
      }
    });
  }

  void mapMarkers() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,
            'lib/assets/images/destination_marker.png')
        .then((icon) => casMarker = icon);

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,
            'lib/assets/images/start_position_marker.png')
        .then((icon) => homeMarker = icon);
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty,
            'lib/assets/images/current_position_marker.png')
        .then((icon) => currentMarker = icon);
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getPolyPoints();
    mapMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
        backgroundColor: Colors.green.shade200,
      ),
      body: Stack(
        children: [
          currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  fortyFiveDegreeImageryEnabled: true,
                  layoutDirection: TextDirection.ltr,
                  mapToolbarEnabled: true,
                  trafficEnabled: true,
                  buildingsEnabled: true,
                  myLocationEnabled: true,
                  onMapCreated: (controller) async {
                    mapController.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                      target: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                      zoom: 23),
                  // polygons: {
                  //   Polygon(
                  //       polygonId: PolygonId('Poly'),
                  //       fillColor: Colors.black,
                  //       points: [homeLocation, LatLng(27.1558, 23.5545)],
                  //       strokeWidth: 5,
                  //       strokeColor: Colors.black)
                  // },
                  // indoorViewEnabled: true,
                  // cameraTargetBounds: CameraTargetBounds(LatLngBounds(
                  //     northeast: homeLocation, southwest: casLocation)),
                  // rotateGesturesEnabled: true,

                  // tileOverlays: {
                  //   TileOverlay(
                  //     tileOverlayId: TileOverlayId('value'),
                  //     tileSize: 30,
                  //     fadeIn: true,
                  //   )
                  // },

                  zoomControlsEnabled: false,
                  markers: {
                    Marker(
                        markerId: const MarkerId('Source Home'),
                        position: homeLocation,
                        icon: homeMarker),
                    Marker(
                        markerId: const MarkerId('Destination CAS'),
                        position: casLocation,
                        icon: casMarker),
                    Marker(
                        icon: currentMarker,
                        markerId: const MarkerId('Moving Object'),
                        position: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!))
                  },
                  polylines: {
                    Polyline(
                        endCap: Cap.roundCap,
                        jointType: JointType.round,
                        startCap: Cap.roundCap,
                        zIndex: 50,
                        polylineId: const PolylineId("Home to CAS"),
                        points: polylineCoordinates,
                        width: 6,
                        color: Colors.blueGrey),
                  },
                )
        ],
      ),
    );
  }
}
