import 'package:charging_station/configs/configs.dart';
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
  Widget? _backgroundImage;

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
      child: _stations != null
          ? Column(
              children: [
                for (final Station station in _stations!)
                  Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Container(
                            height: 170,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                              ),
                            ),
                            child: Image.network(
                              'https://maps.googleapis.com/maps/api/staticmap?center=${station.latitude},${station.longitude}=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C${station.latitude},${station.longitude}&key=${globalConfigs.googleMapAPIKey}',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: Text(
                                  station.name,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 44, 95, 158),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                  onPressed: () {
                                    handleGetDirections(LatLng(
                                        station.latitude, station.longitude));
                                  },
                                  child: const Text('Get Directions'))
                            ],
                          )
                        ],
                      ),
                      const Divider(
                        height: 1,
                      )
                    ],
                  ),
              ],
            )
          : const SizedBox(),
    );
  }
}
