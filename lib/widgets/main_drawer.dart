import 'package:charging_station/providers/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key});

  @override
  ConsumerState<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
  void _handleChangeMapType(MapType type) {
    ref.read(mapConfigurationProvider.notifier).changeMapType(type);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              height: 50,
              child: DrawerHeader(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 5),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                  ),
                  child: Text('Map Settings',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20))),
            ),
            const SizedBox(
              width: double.infinity,
              height: 10,
            ),
            for (final mapType in MapType.values.map((t) => t))
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _handleChangeMapType(mapType);
                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 147, 250, 95)),
                    alignment: AlignmentDirectional.centerStart,
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder()),
                  ),
                  child: Text(
                    mapType.toString().split('.').length > 1
                        ? mapType.toString().split('.')[1].toUpperCase()
                        : mapType.toString().toUpperCase(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
