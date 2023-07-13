import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapConfiguration {
  MapConfiguration({required this.mapType});

  final MapType mapType;
}

final defaultMapConfiguration = MapConfiguration(mapType: MapType.normal);

class MapNotifier extends StateNotifier<MapConfiguration> {
  MapNotifier() : super(defaultMapConfiguration);

  void changeMapType(MapType mapType) {
    state = MapConfiguration(mapType: mapType);
  }
}

final mapConfigurationProvider =
    StateNotifierProvider<MapNotifier, MapConfiguration>(
        (ref) => MapNotifier());
