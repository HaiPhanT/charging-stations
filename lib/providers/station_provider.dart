import 'dart:convert';

import 'package:charging_station/constants/uris.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:charging_station/models/station.dart';

class StationsNotifier extends StateNotifier<List<Station>> {
  StationsNotifier() : super([]);

  List<Station> reset() {
    state = [];
    return state;
  }

  Future<List<Station>> loadStations() async {
    try {
      final url = Uri.https(backEndURL, 'stations.json');
      final response = await http.get(url);
      final Map<String, dynamic> data = json.decode(response.body);
      state = [
        for (final item in data.entries)
          Station(
              id: item.key,
              latitude: item.value['latitude'],
              longitude: item.value['longitude'],
              address: item.value['address'],
              name: item.value['name'])
      ];
      return state;
    } catch (error) {
      print('>> error :: loadStations :: $error');
      throw Exception('Error: $error');
    }
  }

  List<Station> getStations() {
    return state;
  }

  List<Station> addStation(Station station) {
    state = [...state, station];
    return state;
  }

  Future<void> saveStations(Station station) async {
    final url = Uri.https(backEndURL, 'stations.json');
    await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'latitude': station.latitude,
        'longitude': station.longitude,
        'address': station.address,
        'name': station.name,
      }),
    );
  }
}

final stationsProvider =
    StateNotifierProvider<StationsNotifier, List<Station>>((ref) {
  return StationsNotifier();
});
