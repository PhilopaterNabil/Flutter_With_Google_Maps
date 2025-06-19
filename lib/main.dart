import 'package:flutter/material.dart';
import 'package:flutter_with_google_maps/features/ggogle_maps/presentation/views/widgets/custom_google_map.dart';

void main() {
  runApp(const GoogleMapsWithFlutter());
}

class GoogleMapsWithFlutter extends StatelessWidget {
  const GoogleMapsWithFlutter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps with Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CustomGoogleMap(),
    );
  }
}
