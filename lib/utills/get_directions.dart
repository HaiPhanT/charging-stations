import 'dart:convert';

import 'package:charging_station/configs/configs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:charging_station/constants/uris.dart';
import 'package:charging_station/models/direction.dart';

Future<Directions> getDirections(LatLng destination, LatLng origin) async {
  final url = Uri.https(googleMapBaseURL, 'maps/api/directions/json', {
    'destination': '${destination.latitude},${destination.longitude}',
    'origin': '${origin.latitude},${origin.longitude}',
    'key': globalConfigs.googleMapAPIKey
  });
  final response = await http.get(url, headers: {'Content-Type': 'json'});
  return Directions.fromMap(jsonDecode(response.body) as Map<String, dynamic>);
}
