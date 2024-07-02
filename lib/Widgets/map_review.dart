import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '/Widgets/order_tracking_page.dart'; // Ajusta la ruta de importación según sea necesario

class FullMapScreen extends StatefulWidget {
  @override
  _FullMapScreenState createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  late GoogleMapController mapController;
  LatLng _initialPosition = const LatLng(0, 0); // Se actualizará con la ubicación actual
  Location location = Location();
  Set<Marker> _markers = {}; // Set para mantener los marcadores
  Map<MarkerId, String> _markerInfo = {}; // Map para mantener la información de los marcadores

  @override
  void initState() {
    super.initState();
    _determinePosition();
    // Aquí puedes agregar la lógica para cargar los puntos de reciclaje cercanos y agregarlos como marcadores
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
        height: 200, // Ajusta la altura según sea necesario para la previsualización
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
