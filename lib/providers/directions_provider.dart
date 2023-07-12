import 'package:charging_station/constants/locations.dart';
import 'package:charging_station/models/direction.dart';
import 'package:charging_station/utills/get_current_location.dart';
import 'package:charging_station/utills/get_directions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsNotifier extends StateNotifier<Directions> {
  DirectionsNotifier()
      : super(Directions(
            bounds: LatLngBounds(
                southwest:
                    LatLng(defaultLocation.latitude, defaultLocation.longitude),
                northeast: LatLng(
                    defaultLocation.latitude, defaultLocation.longitude)),
            polylinePoints: [],
            totalDistance: '0 km',
            totalDuration: '0 min'));

  Future<Directions> createDirections(LatLng destination) async {
    final currentLocation = await getCurrentLocation();
    state = await getDirections(destination, currentLocation);
    return state;
  }

  void reset() {
    state = Directions(
        bounds: LatLngBounds(
            southwest:
                LatLng(defaultLocation.latitude, defaultLocation.longitude),
            northeast:
                LatLng(defaultLocation.latitude, defaultLocation.longitude)),
        polylinePoints: [],
        totalDistance: '0 km',
        totalDuration: '0 min');
  }
}

final directionsProvider =
    StateNotifierProvider<DirectionsNotifier, Directions>(
        (ref) => DirectionsNotifier());
