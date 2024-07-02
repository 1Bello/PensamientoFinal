import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<LatLng> decodePolyline(String encodedPolyline) {
  List<LatLng> points = <LatLng>[];
  int index = 0;
  int len = encodedPolyline.length;
  int lat = 0;
  int lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encodedPolyline.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encodedPolyline.codeUnitAt(index++) - 63;
      result |= (b & 0x1F) << shift;
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
