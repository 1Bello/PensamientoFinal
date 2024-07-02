import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '/Widgets/order_tracking_page.dart'; // Adjust the import path as necessary

class FullMapScreen extends StatefulWidget {
  @override
  _FullMapScreenState createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  late GoogleMapController mapController;
  LatLng _initialPosition = const LatLng(0, 0);
  Location location = Location();
  Set<Marker> _markers = {};
  Map<MarkerId, String> _markerInfo = {};

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_initialPosition.latitude != 0 && _initialPosition.longitude != 0) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _initialPosition, zoom: 14.0),
        ),
      );
    }
  }

  Future<void> _determinePosition() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      _initialPosition = LatLng(_locationData.latitude!, _locationData.longitude!);
    });

    if (mapController != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _initialPosition, zoom: 14.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderTrackingPage()),
        );
      },
      child: Container(
        height: 200, // Adjust height as necessary for preview
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.green),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14.0,
            ),
            myLocationEnabled: true,
          ),
        ),
      ),
    );
  }
}
