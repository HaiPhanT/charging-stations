import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Size, rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';

// todo: test this approach
Future<BitmapDescriptor> createCustomMarkerV2(BuildContext context) async {
  try {
    return await BitmapDescriptor.fromAssetImage(
        createLocalImageConfiguration(context, size: const Size.square(32)),
        'assets/charger.png');
  } catch (error) {
    print('>> error :: createCustomMarker :: $error');
    throw Exception('Error: $error');
  }
}

Future<BitmapDescriptor> createCustomMarker() async {
  try {
    final value = await getBytesFromAsset('assets/images/charger.png', 64);
    return BitmapDescriptor.fromBytes(value);
  } catch (error) {
    print('>> error :: createCustomMarker :: $error');
    throw Exception('Error: $error');
  }
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}
