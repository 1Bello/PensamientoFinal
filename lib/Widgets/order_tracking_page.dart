import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_webservice/places.dart';
import 'package:flutter/services.dart';

class OrderTrackingPage extends StatefulWidget {
  @override
  OrderTrackingPageState createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  late GoogleMapController mapController;
  loc.Location location = loc.Location();
  LatLng _currentPosition = const LatLng(0, 0);
  bool _isMapInitialized = false;
  Set<Marker> _markers = {}; // Set to hold markers
  Map<MarkerId, String> _markerInfo = {}; // Map to hold marker information
  late BitmapDescriptor customIcon;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyCVQSdkq2E7r1QiOcAEmAVZncFIvVWQ0mM'); // Asegúrate de reemplazar con tu propia API key

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _loadCustomMarker();
  }

  Future<void> _checkLocationPermission() async {
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    _initializeLocation();
  }


  Future<void> _loadCustomMarker() async {
    final ImageConfiguration imageConfiguration = ImageConfiguration();
    BitmapDescriptor.fromAssetImage(imageConfiguration, 'assets/images/basuraman_limpio.png', 
      mipmaps: true)
      .then((icon) {
        setState(() {
          customIcon = icon;
        });
      });
  }

  Future<BitmapDescriptor> resizeImage(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  final Uint8List markerImageBytes = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  return BitmapDescriptor.fromBytes(markerImageBytes);
}

  void _initializeLocation() async {
    loc.LocationData _locationData;

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
    // Add markers with custom icon and fetch place details on tap
    _markers.add(
      Marker(
        markerId: MarkerId('Punto Limpio1'),
        position: LatLng(-33.36413955292655, -70.51871732100369),
        icon: customIcon,
        onTap: () => _onMarkerTapped(MarkerId('Punto Limpio1')),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('Reciclaje Botellas Vidrio'),
        position: LatLng(-33.338572320718775, -70.5434051377558),
        icon: customIcon,
        onTap: () => _onMarkerTapped(MarkerId('Reciclaje Botellas Vidrio')),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('Punto Limpio TriCiclos'),
        position: LatLng(-33.38725164393464, -70.49695752663585),
        icon: customIcon,
        onTap: () => _onMarkerTapped(MarkerId('Punto Limpio TriCiclos')),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('Punto Verde'),
        position: LatLng(-33.39867865294377, -70.58208427419848),
        icon: customIcon,
        onTap: () => _onMarkerTapped(MarkerId('Punto Verde')),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('Punto Limpio2'),
        position: LatLng(-33.40383777894912, -70.56869468732114),
        icon: customIcon,
        onTap: () => _onMarkerTapped(MarkerId('Punto Limpio2')),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('Centro de reciclaje recoleta'),
        position: LatLng(-33.39323257651344, -70.64147910829533),
        icon: customIcon,
        onTap: () => _onMarkerTapped(MarkerId('Centro de reciclaje recoleta')),
      ),
    );

    setState(() {});
  }

  void _onMarkerTapped(MarkerId markerId) async {
    final placeId = _getPlaceIdFromMarkerId(markerId); // Function to get placeId based on markerId
    if (placeId != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);
      if (detail.status == "OK") {
        final result = detail.result;
        String info = """
          Name: ${result.name}
          Address: ${result.formattedAddress}
          Phone: ${result.formattedPhoneNumber}
          Website: ${result.website}
        """;
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
  }

  String? _getPlaceIdFromMarkerId(MarkerId markerId) {
    // Return placeId based on markerId. You need to maintain a map of markerId to placeId.
    Map<String, String> markerToPlaceId = {
      'Punto Limpio1': 'ChIJAXUymObLYpYRP-wT5Wjhd-o',
      'Reciclaje Botellas Vidrio': 'ChIJNWcuD57JYpYRW6JlnMkbcBw',
      'Punto Limpio TriCiclos': 'ChIJWbEHEJDOYpYRG3mIbh7ga88',
      'Punto Verde': 'EjxQw61vIFhJIDE2MDQsIDc2MzAyNjMgVml0YWN1cmEsIFJlZ2nDs24gTWV0cm9wb2xpdGFuYSwgQ2hpbGUiMRIvChQKEglF_5mSLs9ilhEbyYEt6bJaFxDEDCoUChIJZ9485y7PYpYRCHvMNFJCW9A',
      'Punto Limpio2': 'ChIJ50D9YNnOYpYRcG-Kc0Nb0Nc',
      'Centro de reciclaje recoleta': 'ChIJOR1iSQzGYpYRuBuFodSX5OM',
    };
    return markerToPlaceId[markerId.value];
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

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
