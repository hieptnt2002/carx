import 'package:carx/utilities/api_constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapGoogleWidget extends StatefulWidget {
  const MapGoogleWidget({super.key});

  @override
  State<MapGoogleWidget> createState() => _MapGoogleWidgetState();
}

class _MapGoogleWidgetState extends State<MapGoogleWidget> {
  LatLng destination = const LatLng(16.489068, 107.546445);
  LatLng sourceLocation = const LatLng(16.070260, 108.214430);
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor .defaultMarker;

  void getLocation() async {
    Location location = Location();
    location.getLocation().then((location) {
      print('${location.longitude} ${location.latitude}');
      currentLocation = location;
    });
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size:Size.fromHeight(12),), 'assets/images/no-notify.png')
        .then((value) => currentLocationIcon = value);
      
    setState(() {});
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_API_KEY,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((point) {
        print(point.latitude.toString());
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    getPolyPoints();
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: currentLocation == null
          ? Center(child: Text('Loading'))
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 13.5,
              ),
              // polylines: {
              //   Polyline(
              //       polylineId: const PolylineId('route'),
              //       points: polylineCoordinates,
              //       color: AppColors.secondary,
              //       width: 6),
              // },
              markers: {
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  icon: currentLocationIcon,
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
                Marker(
                  markerId: const MarkerId('sourceLocation'),
                  position: sourceLocation,
                ),
                Marker(
                  markerId: const MarkerId('destination'),
                  position: destination,
                ),
              },
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MapGoogleWidget(),
  ));
}
