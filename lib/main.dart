import 'package:charging_station/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  background: const Color.fromARGB(255, 56, 49, 66),
);

final theme = ThemeData().copyWith(
  useMaterial3: true,
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  // * NOTE: GoogleFont is disabled because it uses a different http version than flutter_polyline_points
  // textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
  //   titleSmall: GoogleFonts.ubuntuCondensed(
  //     fontWeight: FontWeight.bold,
  //   ),
  //   titleMedium: GoogleFonts.ubuntuCondensed(
  //     fontWeight: FontWeight.bold,
  //   ),
  //   titleLarge: GoogleFonts.ubuntuCondensed(
  //     fontWeight: FontWeight.bold,
  //   ),
  // ),
);

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Charging Stations',
      theme: theme,
      home: const MainScreen(),
    );
  }
}
