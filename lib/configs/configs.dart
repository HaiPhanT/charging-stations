import 'package:flutter_dotenv/flutter_dotenv.dart';

class Configs {
  Configs({required this.googleMapAPIKey});

  String googleMapAPIKey;
}

final globalConfigs =
    Configs(googleMapAPIKey: dotenv.env['GOOGLE_MAP_API_KEY'] ?? '');
