import 'package:charging_station/models/direction.dart';
import 'package:charging_station/models/station.dart';
import 'package:charging_station/providers/directions_provider.dart';
import 'package:charging_station/providers/screen_provider.dart';
import 'package:charging_station/providers/station_provider.dart';
import 'package:charging_station/widgets/google_map_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationListWidget extends ConsumerStatefulWidget {
  const StationListWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _StationListWidgetState();
  }
}

class _StationListWidgetState extends ConsumerState<StationListWidget> {
  List<Station>? _stations;

  Future<void> handleGetDirections(LatLng destination) async {
    try {
      ref.read(screenProvider.notifier).switchToScreen(
          ScreenInfo(screen: const GoogleMapWidget(), index: 0));
      await ref.read(directionsProvider.notifier).createDirections(destination);
    } catch (error) {
      print('>> error :: handleGetDirections :: $error');
    }
  }

  @override
  void initState() {
    setState(() {
      _stations = ref.read(stationsProvider.notifier).getStations();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: _stations != null
            ? [
                for (final Station station in _stations!)
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 243, 96, 96)),
                              padding: const EdgeInsets.all(16),
                              child: ListTile(
                                title: Text(station.name),
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                handleGetDirections(LatLng(
                                    station.latitude, station.longitude));
                              },
                              child: const Text('Get Directions'))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  )
              ]
            : [],
      ),
    );
  }
}
