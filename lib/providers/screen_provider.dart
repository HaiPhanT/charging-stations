import 'package:charging_station/widgets/google_map_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScreenInfo {
  ScreenInfo({required this.screen, required this.index});

  final Widget screen;
  final int index;
}

class ScreenNotifier extends StateNotifier<ScreenInfo> {
  ScreenNotifier()
      : super(ScreenInfo(screen: const GoogleMapWidget(), index: 0));

  void switchToScreen(ScreenInfo screenInfo) {
    state = ScreenInfo(screen: screenInfo.screen, index: screenInfo.index);
  }
}

final screenProvider = StateNotifierProvider<ScreenNotifier, ScreenInfo>(
    (ref) => ScreenNotifier());
