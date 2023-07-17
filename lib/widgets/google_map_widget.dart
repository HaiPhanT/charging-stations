import 'package:charging_station/utills/create_custom_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:charging_station/models/direction.dart';
import 'package:charging_station/models/station.dart';
import 'package:charging_station/providers/directions_provider.dart';
import 'package:charging_station/providers/map_provider.dart';
import 'package:charging_station/screens/add_station_screen.dart';
import 'package:charging_station/constants/locations.dart';
import 'package:charging_station/providers/station_provider.dart';

class GoogleMapWidget extends ConsumerStatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  ConsumerState<GoogleMapWidget> createState() {
    return _GoogleMapState();
  }
}

class _GoogleMapState extends ConsumerState<GoogleMapWidget> {
  List<Station> _stations = [];
  MapConfiguration _mapConfiguration = defaultMapConfiguration;
  Directions? _directions;
  Uint8List? _iconByteData;
  bool _ready = false;

  void handleAppBarPressed() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddStationScreen()));
  }

  Polyline createPolyline(Directions directions) {
    return Polyline(
        polylineId:
            const PolylineId('overview_polyline'), // todo: create unique ID
        color: Colors.red,
        width: 5,
        points: _directions!.polylinePoints
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList());
  }

  void handleGoogleMapTap() {
    ref.read(directionsProvider.notifier).reset();
  }

  @override
  void initState() {
    ref.read(stationsProvider.notifier).loadStations().then(
      (stations) {
        setState(() {
          _stations = stations;
          _ready = true;
        });
      },
    );

    getBytesFromAsset('assets/images/charger.png', 96).then((value) {
      setState(() {
        _iconByteData = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _directions = ref.watch(directionsProvider);
    _mapConfiguration = ref.watch(mapConfigurationProvider);

    return Scaffold(
      body: _ready
          ? GoogleMap(
              key: GlobalKey(),
              onTap: (latLng) {
                handleGoogleMapTap();
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  defaultLocation.latitude,
                  defaultLocation.longitude,
                ),
                zoom: 16,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: _mapConfiguration.mapType,
              markers: _stations.isNotEmpty
                  ? {
                      for (final station in _stations)
                        Marker(
                            markerId: const MarkerId('m1'),
                            position: LatLng(
                              station.latitude,
                              station.longitude,
                            ),
                            icon: _iconByteData != null
                                ? BitmapDescriptor.fromBytes(_iconByteData!)
                                : BitmapDescriptor.defaultMarker,
                            infoWindow: InfoWindow(title: station.name)),
                    }
                  : {},
              polylines:
                  _directions != null ? {createPolyline(_directions!)} : {},
            )
          : const SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: ElevatedButton(
          onPressed: handleAppBarPressed,
          style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(255, 255, 247, 129))),
          child: const Text('Add Station',
              style: TextStyle(color: Color.fromARGB(255, 24, 19, 53)))),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
