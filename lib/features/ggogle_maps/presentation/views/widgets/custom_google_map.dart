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
    initialCameraPostion = const CameraPosition(zoom: 10, target: LatLng(31, 30));
    location = Location();
    updateMyLocation();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    super.dispose();
  }

  GoogleMapController? googleMapController;
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      markers: markers,
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
      googleMapController!.setMapStyle(nightMapStyle);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> checkAndRequestLocationServices() async {
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        // TODO: show error bar
      }
    }
  }

  Future<bool> checkAndRequestLocationPermission() async {
    var permissionStatus = await location.hasPermission();

    if (permissionStatus == PermissionStatus.deniedForever) {
      return false;
    }

    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  void getLocationData() async {
    location.changeSettings(distanceFilter: 2);
    location.onLocationChanged.listen((locationData) {
      var cameraPosition = CameraPosition(
        target: LatLng(locationData.latitude!, locationData.longitude!),
        zoom: 13,
      );
      var myLocationMarker = Marker(
        markerId: const MarkerId('myLocation'),
        position: LatLng(locationData.latitude!, locationData.longitude!),
        infoWindow: const InfoWindow(title: 'My Location'),
      );
      setState(() {
        markers.add(myLocationMarker);
      });
      googleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  void updateMyLocation() async {
    await checkAndRequestLocationServices();
    var hasPermissionStatus = await checkAndRequestLocationPermission();
    if (hasPermissionStatus) {
      getLocationData();
    } else {
      // TODO: show error bar
    }
  }
}

// inquire about Location Services
// request permission from user
// get location from user
// display location on map
