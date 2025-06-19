import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPostion;
  late Location location;

  @override
  void initState() {
    initialCameraPostion = const CameraPosition(
      target: LatLng(31, 30),
      zoom: 10,
    );
    location = Location();
    checkAndRequestLocationServices();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      initialCameraPosition: initialCameraPostion,
      onMapCreated: (controller) {
        googleMapController = controller;
        initMapStyle();
      },
    );
  }

  void initMapStyle() async {
    DefaultAssetBundle.of(context).loadString('assets/map_styles/night_map_style.json');
    try {
      final nightMapStyle = await rootBundle.loadString('assets/map_styles/night_map_style.json');
      googleMapController.setMapStyle(nightMapStyle);
    } catch (e) {
      log(e.toString());
    }
  }

  void checkAndRequestLocationServices() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        // TODO: show error bar
      }
    }
    checkAndRequestLocationPermission();
  }

  void checkAndRequestLocationPermission() async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();

      if (permissionStatus != PermissionStatus.granted) {
        // TODO: show error bar
      }
    }
  }
}

// inquire about Location Services
// request permission from user
// get location from user
// display location on map
