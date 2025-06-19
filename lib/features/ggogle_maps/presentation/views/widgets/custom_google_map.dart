import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_with_google_maps/core/utils/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPostion;

  late LocationService locationService;

  @override
  void initState() {
    initialCameraPostion = const CameraPosition(zoom: 10, target: LatLng(31, 30));
    locationService = LocationService();
    updateMyLocation();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    super.dispose();
  }

  bool isFirstCall = true;
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

  void updateMyLocation() async {
    await locationService.checkAndRequestLocationServices();
    var hasPermissionStatus = await locationService.checkAndRequestLocationPermission();
    if (hasPermissionStatus) {
      locationService.getRealTimeLocationData((locationData) {
        setMyLocatinMarker(locationData);
        updateMyCamera(locationData);
      });
    } else {
      // TODO: show error bar
    }
  }

  void updateMyCamera(LocationData locationData) {
    // var cameraPosition = CameraPosition(
    //   target: LatLng(locationData.latitude!, locationData.longitude!),
    //   zoom: 13,
    // );
    // googleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    if (isFirstCall) {
      var cameraPosition = CameraPosition(
        target: LatLng(locationData.latitude!, locationData.longitude!),
        zoom: 13,
      );
      googleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      isFirstCall = false;
    } else {
      googleMapController?.animateCamera(
          CameraUpdate.newLatLng(LatLng(locationData.latitude!, locationData.longitude!)));
    }
  }

  void setMyLocatinMarker(LocationData locationData) {
    var myLocationMarker = Marker(
      markerId: const MarkerId('myLocation'),
      position: LatLng(locationData.latitude!, locationData.longitude!),
      infoWindow: const InfoWindow(title: 'My Location'),
    );
    setState(() {
      markers.add(myLocationMarker);
    });
  }
}

// inquire about Location Services
// request permission from user
// get location from user
// display location on map
