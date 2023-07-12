import 'package:charging_station/models/station.dart';
import 'package:charging_station/providers/station_provider.dart';
import 'package:charging_station/utills/get_current_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddStationScreen extends ConsumerStatefulWidget {
  const AddStationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddStationScreenState();
  }
}

class _AddStationScreenState extends ConsumerState<AddStationScreen> {
  // todo: get current location and point the camera to the current one
  late LatLng _pickedLocation = const LatLng(0, 0);
  final _formKey = GlobalKey<FormState>();
  String _stationName = 'Station 1';

  void _handleGoogleMapTap(LatLng location) {
    setState(() {
      _pickedLocation = location;
    });
  }

  void _handleFormSubmit() {
    final formValid = _formKey.currentState!.validate();

    if (formValid) {
      final station = Station(
          latitude: _pickedLocation.latitude,
          longitude: _pickedLocation.longitude,
          address: '',
          name: _stationName);
      ref.read(stationsProvider.notifier).addStation(station);
      ref.read(stationsProvider.notifier).saveStations(station);
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    getCurrentLocation().then((value) {
      setState(() {
        _pickedLocation = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: GoogleMap(
              key: GlobalKey(),
              onTap: _handleGoogleMapTap,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _pickedLocation.latitude,
                  _pickedLocation.longitude,
                ),
                zoom: 16,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: {
                Marker(
                    markerId: MarkerId(
                        '${_pickedLocation.latitude}-${_pickedLocation.longitude}'),
                    position: _pickedLocation),
              },
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Latitude: ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 20)),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        child: TextField(
                          controller: TextEditingController.fromValue(
                              TextEditingValue(
                                  text: _pickedLocation.latitude
                                      .toStringAsFixed(7))),
                          enabled: false,
                          decoration: const InputDecoration.collapsed(
                              hintText: 'latitude',
                              hintStyle: TextStyle(color: Colors.white)),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text('Longitude: ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 20)),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        child: TextField(
                          controller: TextEditingController.fromValue(
                              TextEditingValue(
                                  text: _pickedLocation.longitude
                                      .toStringAsFixed(7))),
                          enabled: false,
                          decoration: const InputDecoration.collapsed(
                              hintText: 'latitude',
                              hintStyle: TextStyle(color: Colors.white)),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Text('Station Name: ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 20)),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        child: TextFormField(
                          initialValue: 'Station 1',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                          onChanged: (value) {
                            _stationName = value;
                          },
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: _handleFormSubmit,
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 50, 51, 48)),
                    ),
                    child: const Text(
                      'Add station',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
