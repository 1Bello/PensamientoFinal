import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/directions.dart' as dir;
import 'package:flutter/services.dart' show rootBundle;

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
  late BitmapDescriptor customIcon;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyCVQSdkq2E7r1QiOcAEmAVZncFIvVWQ0mM'); // Replace with your own API key
  dir.GoogleMapsDirections _directions =
      dir.GoogleMapsDirections(apiKey: 'AIzaSyCVQSdkq2E7r1QiOcAEmAVZncFIvVWQ0mM'); // Replace with your own API key
  Set<Polyline> _polylines = {}; // Set to hold polylines

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

  void _initializeLocation() async {
    loc.LocationData _locationData;

    try {
      _locationData = await location.getLocation();
      setState(() {
        _currentPosition =
            LatLng(_locationData.latitude!, _locationData.longitude!);
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
        onTap: () =>
            _onMarkerTapped(MarkerId('Reciclaje Botellas Vidrio')),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('Punto Limpio TriCiclos'),
        position: LatLng(-33.38725164393464, -70.49695752663585),
        icon: customIcon,
        onTap: () =>
            _onMarkerTapped(MarkerId('Punto Limpio TriCiclos')),
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
        onTap: () =>
            _onMarkerTapped(MarkerId('Centro de reciclaje recoleta')),
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
              title: Text('Información del lugar',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${result.name}", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  Text("Address: ${result.formattedAddress}",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  Text("Phone: ${result.formattedPhoneNumber ?? 'N/A'}",
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  Text("Website: ${result.website ?? 'N/A'}",
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cerrar', style: TextStyle(fontSize: 16)),
                ),
                TextButton(
                  onPressed: () {
                    _drawRoute(
                      startLat: _currentPosition.latitude,
                      startLng: _currentPosition.longitude,
                      endLat: result.geometry!.location.lat,
                      endLng: result.geometry!.location.lng,
                    );
                  },
                  child: Text('Cómo llegar', style: TextStyle(fontSize: 16)),
                ),
              ],
            );
          },
        );
      }
    }
  }

 void _drawRoute(
    {required double startLat,
    required double startLng,
    required double endLat,
    required double endLng}) async {
  dir.DirectionsResponse? response = await _directions.directions(
    dir.Location(
        lat: startLat,
        lng: startLng,
      ),
      dir.Location(
        lat: endLat,
        lng: endLng,
      ),
      travelMode: dir.TravelMode.driving,
    );

  if (response != null &&
      response.status == "OK" &&
      response.routes.isNotEmpty) {
    List<LatLng> points =
        decodePolyline(response.routes[0].overviewPolyline!.points);
    setState(() {
      _polylines.add(Polyline(
        polylineId: PolylineId('route'),
        points: points,
        color: Colors.blue,
        width: 5,
      ));
    });
  }
}


  String? _getPlaceIdFromMarkerId(MarkerId markerId) {
    // Return placeId based on markerId. You need to maintain a map of markerId to placeId.
    Map<String, String> markerToPlaceId = {
      'Punto Limpio1': 'ChIJAXUymObLYpYRP-wT5Wjhd-o',
      'Reciclaje Botellas Vidrio': 'ChIJNWcuD57JYpYRW6JlnMkbcBw',
      'Punto Limpio TriCiclos': 'ChIJWbEHEJDOYpYRG3mIbh7ga88',
      'Punto Verde':
          'EjxQw61vIFhJIDE2MDQsIDc2MzAyNjMgVml0YWN1cmEsIFJlZ2nDs24gTWV0cm9wb2xpdGFuYSwgQ2hpbGUiMRIvChQKEglF_5mSLs9ilhEbyYEt6bJaFxDEDCoUChIJZ9485y7PYpYRCHvMNFJCW9A',
      'Punto Limpio2': 'ChIJtQW7rsHbYpYRorNaIzUpp6k',
      'Centro de reciclaje recoleta': 'ChIJOR1iSQzGYpYRuBuFodSX5OM',
    };

    return markerToPlaceId[markerId.value];
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1E5;
      double longitude = lng / 1E5;
      points.add(LatLng(latitude, longitude));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguimiento de Pedidos'),
      ),
      body: _isMapInitialized
          ? GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                _addMarkers();
              },
              initialCameraPosition:
                  CameraPosition(target: _currentPosition, zoom: 14.0),
              markers: _markers,
              polylines: _polylines,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
