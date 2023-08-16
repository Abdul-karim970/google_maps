import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map/google_map_live_location.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  void location() async {
    Location location = Location();
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      location.requestPermission();
    }
  }

  late GoogleMapController mapController;
  Set<Marker> markers = {
    Marker(
        markerId: MarkerId(const LatLng(29.394859, 71.704117).toString()),
        position: const LatLng(29.394859, 71.704117),
        infoWindow: InfoWindow(
          title: const LatLng(29.394859, 71.704117).toString(),
          snippet: 'Not Yet',
        ))
  };
  MapType mapType = MapType.satellite;

  final _initialCameraPosition = const CameraPosition(
    target: LatLng(29.394859, 71.704117),
    zoom: 20,
  );

  @override
  void initState() {
    super.initState();
    location();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
        backgroundColor: Colors.green.shade200,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GoogleMapLiveLocation(),
                    ));
              },
              icon: const Icon(Icons.next_plan_outlined))
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onLongPress: (latlng) {
              LatLng markedLatLng = latlng;
              markers.add(Marker(
                  markerId: MarkerId(markedLatLng.toString()),
                  position: markedLatLng,
                  infoWindow: InfoWindow(
                    title: markedLatLng.toString(),
                    snippet: 'Not Yet',
                  )));
              setState(() {});
            },
            buildingsEnabled: true,
            compassEnabled: true,
            indoorViewEnabled: true,
            mapToolbarEnabled: true,
            mapType: mapType,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            rotateGesturesEnabled: true,
            trafficEnabled: true,
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: _initialCameraPosition,
            markers: markers,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (mapType == MapType.satellite) {
            setState(() {
              mapType = MapType.normal;
            });
          } else {
            setState(() {
              mapType = MapType.hybrid;
            });
          }
          setState(() {});
        },
        child: const Icon(
          Icons.change_circle_outlined,
          size: 35,
        ),
      ),
    );
  }
}
