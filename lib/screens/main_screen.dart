import 'package:charging_station/providers/screen_provider.dart';
import 'package:charging_station/widgets/google_map_widget.dart';
import 'package:charging_station/widgets/main_drawer.dart';
import 'package:charging_station/widgets/station_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  ScreenInfo _currentScreenInfo =
      ScreenInfo(screen: const GoogleMapWidget(), index: 0);

  @override
  Widget build(BuildContext context) {
    _currentScreenInfo = ref.watch(screenProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Charging Stations'),
      ),
      drawer: const MainDrawer(),
      body: _currentScreenInfo.screen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            ref.read(screenProvider.notifier).switchToScreen(
                ScreenInfo(screen: const GoogleMapWidget(), index: 0));
          } else {
            ref.read(screenProvider.notifier).switchToScreen(
                ScreenInfo(screen: const StationListWidget(), index: 1));
          }
        },
        currentIndex: _currentScreenInfo.index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Your Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ev_station),
            label: 'Your Stations',
          ),
        ],
      ),
    );
  }
}
