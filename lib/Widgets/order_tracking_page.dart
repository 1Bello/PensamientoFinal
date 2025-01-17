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
  Set<Marker> _markers = {};
  late BitmapDescriptor customIcon;
  GoogleMapsPlaces _places = GoogleMapsPlaces(
    apiKey: 'AIzaSyCVQSdkq2E7r1QiOcAEmAVZncFIvVWQ0mM',
  );
  dir.GoogleMapsDirections _directions = dir.GoogleMapsDirections(
    apiKey: 'AIzaSyCVQSdkq2E7r1QiOcAEmAVZncFIvVWQ0mM',
  );
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _loadCustomMarker();
  }

  void closeInfoMenu() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
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

  Future<BitmapDescriptor> _createCustomMarker() async {
    final ByteData data = await rootBundle.load('assets/images/basuraman_limpio.png');
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 250,
      targetHeight: 200,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedMarker = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(resizedMarker);
  }

  Future<void> _loadCustomMarker() async {
    customIcon = await _createCustomMarker();
    setState(() {});
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

    _addMarkers();
  }

  Future<double> _calculateRouteDistance(double startLat, double startLng, double endLat, double endLng) async {
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
      final route = response.routes[0];
      return route.legs[0].distance!.value / 1000.0; // distance in kilometers
    } else {
      throw Exception("Error calculating route distance");
    }
  }

 final Map<String, String> _markerInfo = {
    'Punto Limpio Lo Barnechea': 'papel y diario, cartón, vidrio, plástico (rígido, flexible y botellas PET 1), tetrapak, aluminio, aceite de cocina, libros, tapas de plástico, cápsulas de café, bolsas reutilizables',
    'Reciclaje Botellas Vidrio': 'Additional info for Reciclaje Botellas Vidrio',
    'Punto Limpio TriCiclos': 'Additional info for Punto Limpio TriCiclos',
    'Punto Verde': 'Additional info for Punto Verde',
    'Punto Limpio2': 'Additional info for Punto Limpio2',
    'Centro de reciclaje recoleta': 'Additional info for Centro de reciclaje recoleta',
    'Punto Limpio Cantagallo': 'Additional info for Centro de reciclaje recoleta',
    'Punto Limpio Observatorio': 'Additional info for Centro de reciclaje recoleta',
  };

  final Map<String, String> _markerhorario = {
    'Punto Limpio Lo Barnechea': 'Martes - Domingo: 8:30AM - 20:00PM',
    'Reciclaje Botellas Vidrio': 'Additional info for Reciclaje Botellas Vidrio',
    'Punto Limpio TriCiclos': 'Additional info for Punto Limpio TriCiclos',
    'Punto Verde': 'Additional info for Punto Verde',
    'Punto Limpio2': 'Additional info for Punto Limpio2',
    'Centro de reciclaje recoleta': 'Additional info for Centro de reciclaje recoleta',
    'Punto Limpio Cantagallo': 'Additional info for Centro de reciclaje recoleta',
    'Punto Limpio Observatorio': 'Additional info for Centro de reciclaje recoleta',
  };

  void _addMarkers() {
    final markers = [
      {'id': 'Punto Limpio Lo Barnechea', 'position': LatLng(-33.36765930525515, -70.51881189071077)},
      {'id': 'Reciclaje Botellas Vidrio', 'position': LatLng(-33.338572320718775, -70.5434051377558)},
      {'id': 'Punto Limpio TriCiclos', 'position': LatLng(-33.416125509883386, -70.53949971882103)},
      {'id': 'Punto Verde', 'position': LatLng(-33.39867865294377, -70.58208427419848)},
      {'id': 'Punto Limpio2', 'position': LatLng(-33.40383777894912, -70.56869468732114)},
      {'id': 'Centro de reciclaje recoleta', 'position': LatLng(-33.39323257651344, -70.64147910829533)},
      {'id': 'Punto Limpio Cantagallo', 'position': LatLng(-33.37350266295285, -70.5192714576699)},
      {'id': 'Punto Limpio Observatorio', 'position': LatLng(-33.4039519532913, -70.53741461263681)},
    ];

    for (var markerData in markers) {
      final markerId = markerData['id'] as String;
      final position = markerData['position'] as LatLng;

      _calculateRouteDistance(_currentPosition.latitude, _currentPosition.longitude, position.latitude, position.longitude)
        .then((distance) {
          setState(() {
            _markers.add(
              Marker(
                markerId: MarkerId(markerId),
                position: position,
                icon: customIcon,
                onTap: () => _onMarkerTapped(MarkerId(markerId)),
                infoWindow: InfoWindow(
                  title: markerId,
                  snippet: '${distance.toStringAsFixed(2)} km',
                ),
              ),
            );
          });
        })
        .catchError((e) {
          print('Error calculating route distance: $e');
        });
    }
  }

  void _onMarkerTapped(MarkerId markerId) async {
    final placeId = _getPlaceIdFromMarkerId(markerId);
    if (placeId != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);
      if (detail.status == "OK") {
        final result = detail.result;
        String extraInfo = _markerInfo[markerId.value] ?? 'No additional info available';
        String extraHorario = _markerhorario[markerId.value] ?? 'No additional info available';
        String info = """
          Name: ${result.name}
          Address: ${result.formattedAddress}
          Phone: ${result.formattedPhoneNumber}
          Website: ${result.website}
          info: $extraInfo
          horario: $extraHorario
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
                  Text("Name: ${result.name}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  SelectableText("Address: ${result.formattedAddress}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  // SizedBox(height: 5),
                  // Text("Phone: ${result.formattedPhoneNumber ?? 'N/A'}",
                  //     style: TextStyle(fontSize: 16)),
                  // SizedBox(height: 5),
                  // Text("Website: ${result.website ?? 'N/A'}",
                  //     style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  Text("Info: $extraInfo",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("Horario: $extraHorario",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
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
                    closeInfoMenu();
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

  void _drawRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
  }) async {
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
      List<LatLng> points = decodePolyline(response.routes[0].overviewPolyline!.points);
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
    Map<String, String> markerToPlaceId = {
      'Punto Limpio Lo Barnechea': 'ChIJi_REhJvLYpYRk3qtqHILZI4',
      'Reciclaje Botellas Vidrio': 'ChIJNWcuD57JYpYRW6JlnMkbcBw',
      'Punto Limpio TriCiclos': 'ChIJWbEHEJDOYpYRG3mIbh7ga88',
      'Punto Verde':
        'EjxQw61vIFhJIDE2MDQsIDc2MzAyNjMgVml0YWN1cmEsIFJlZ2nDs24gTWV0cm9wb2xpdGFuYSwgQ2hpbGUiMRIvChQKEglF_5mSLs9ilhEbyYEt6bJaFxDEDCoUChIJZ9485y7PYpYRCHvMNFJCW9A',
      'Punto Limpio2': 'ChIJ50D9YNnOYpYRcG-Kc0Nb0Nc',
      'Centro de reciclaje recoleta': 'ChIJOR1iSQzGYpYRuBuFodSX5OM',
      'Punto Limpio Cantagallo': 'ChIJiw-el_vLYpYR_-5FOptDzH8',
      'Punto Limpio Observatorio': 
        'EkRDYW0uIGRlbCBPYnNlcnZhdG9yaW8gMTkwMCwgTGFzIENvbmRlcywgUmVnacOzbiBNZXRyb3BvbGl0YW5hLCBDaGlsZSIxEi8KFAoSCT3Q496izmKWEaL3P3qfrQCTEOwOKhQKEgmp_BH1pM5ilhEt-DCUWJj6Gg',

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
      body: _isMapInitialized
          ? GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                _addMarkers();
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: _currentPosition, zoom: 14.0),
                  ),
                );
              },
              initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 14.0),
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
