import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class OrderTrackingPage extends StatefulWidget {
  @override
  OrderTrackingPageState createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  late GoogleMapController mapController;
  Location location = Location();
  LatLng _currentPosition = const LatLng(0, 0);
  bool _isMapInitialized = false;
  Set<Marker> _markers = {}; // Set to hold markers
  Map<MarkerId, String> _markerInfo = {}; // Map to hold marker information

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
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

    _initializeLocation();
  }

  void _initializeLocation() async {
    LocationData _locationData;

    try {
      _locationData = await location.getLocation();
      setState(() {
        _currentPosition = LatLng(_locationData.latitude!, _locationData.longitude!);
        _isMapInitialized = true;
      });

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 14.0),
        ),
      );
    } catch (e) {
      print("Error getting location: $e");
    }

    // Add markers after initializing location
    _addMarkers();
  }

  void _addMarkers() {
    // Add markers to the set with associated information
    _markers.add(
      Marker(
        markerId: MarkerId('Punto Limpio1'),
        position: LatLng(-33.36413955292655, -70.51871732100369),
        // Custom icon for the marker
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: () => _onMarkerTapped(MarkerId('Punto Limpio1')),
      ),
    );
    _markerInfo[MarkerId('Punto Limpio1')] = 'Punto Limpio, Av. Raúl Labbé 12.099, 7690554 Lo Barnechea, Región Metropolitana';

    _markers.add(
      Marker(
        markerId: MarkerId('Reciclaje Botellas Vidrio'),
        position: LatLng(-33.338572320718775, -70.5434051377558),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: () => _onMarkerTapped(MarkerId('Reciclaje Botellas Vidrio')),
      ),
    );
    _markerInfo[MarkerId('Reciclaje Botellas Vidrio')] = 'Reciclaje Botellas Vidrio, Cam. Los Trapenses 3515, 7700148 Lo Barnechea, Región Metropolitana';

    _markers.add(
      Marker(
        markerId: MarkerId('Punto Limpio TriCiclos'),
        position: LatLng(-33.38725164393464, -70.49695752663585),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: () => _onMarkerTapped(MarkerId('Punto Limpio TriCiclos')),
      ),
    );
    _markerInfo[MarkerId('Punto Limpio TriCiclos')] = 'Punto Limpio TriCiclos, Universidad del Desarrollo - UDD - Av Plaza 680, 7610615 Las Condes, Región Metropolitana';

     _markers.add(
      Marker(
        markerId: MarkerId('Punto Verde'),
        position: LatLng(-33.39867865294377, -70.58208427419848),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: () => _onMarkerTapped(MarkerId('Punto Verde')),
      ),
    );
    _markerInfo[MarkerId('Punto Verde')] = 'Punto Verde, Cerro Colorado 5051, 7560995 Las Condes, Región Metropolitana';

    _markers.add(
      Marker(
        markerId: MarkerId('Punto Limpio2'),
        position: LatLng(-33.40383777894912, -70.56869468732114),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: () => _onMarkerTapped(MarkerId('Punto Limpio2')),
      ),
    );
    _markerInfo[MarkerId('Punto Limpio2')] = 'Punto Limpio, Las Condes, Región Metropolitana';

    _markers.add(
      Marker(
        markerId: MarkerId('Centro de reciclaje recoleta'),
        position: LatLng(-33.39323257651344, -70.64147910829533),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: () => _onMarkerTapped(MarkerId('Centro de reciclaje recoleta')),
      ),
    );
    _markerInfo[MarkerId('Centro de reciclaje recoleta')] = 'Centro de reciclaje recoleta, 8440697 Recoleta, Región Metropolitana';
    // Set the state to update the map with the newly added markers
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onMarkerTapped(MarkerId markerId) {
    // Retrieve the marker's information
    String? info = _markerInfo[markerId];
    if (info != null) {
      // Display the information in a dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Info'),
            content: Text(info),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centros de Reciclaje'),
      ),
      body: _isMapInitialized
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 14.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
