import 'dart:developer';

// import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_with_google_maps/features/ggogle_maps/data/models/place_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({super.key});

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late CameraPosition initialCameraPostion;

  @override
  void initState() {
    initialCameraPostion = const CameraPosition(
      target: LatLng(31, 30),
      zoom: 10,
    );
    initMarkers();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          markers: markers,
          initialCameraPosition: initialCameraPostion,
          // cameraTargetBounds: CameraTargetBounds(
          //     LatLngBounds(southwest: LatLng(31, 29), northeast: LatLng(31, 30))),
          onMapCreated: (controller) {
            googleMapController = controller;
            initMapStyle();
          },
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: ElevatedButton(
            onPressed: () {
              googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(31, 30),
                    zoom: 13,
                  ),
                ),
              );
            },
            child: const Text('Change location'),
          ),
        ),
      ],
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

  // Future<Uint8List> getImageFromRawData(String imagePath, double width, double height) async {
  //   var imageData = await rootBundle.load(imagePath);
  //   var imageCodec = await ui.instantiateImageCodec(
  //     imageData.buffer.asUint8List(),
  //     targetHeight: height.round(),
  //     targetWidth: width.round(),
  //   );
  //   var imageFrameInfo = await imageCodec.getNextFrame();
  //   var imageByteData = await imageFrameInfo.image.toByteData(format: ui.ImageByteFormat.png);
  //   return imageByteData!.buffer.asUint8List();
  // }

  void initMarkers() async {
    var customMarkerIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/images/icons8-marker-50.png');

    // var customMarkerIcon = BitmapDescriptor.fromBytes(
    //     await getImageFromRawData('assets/images/icons8-marker-50.png', 100, 100));
    PlaceModel.places
        .map(
          (placeModel) => markers.add(
            Marker(
              markerId: MarkerId(placeModel.id.toString()),
              infoWindow: InfoWindow(title: placeModel.name),
              icon: customMarkerIcon,
              position: placeModel.latLng,
            ),
          ),
        )
        .toSet();
    setState(() {});
    // var myMarker = const Marker(
    //   markerId: MarkerId('1'),
    //   position: LatLng(31, 30),
    // );
    // markers.add(myMarker);
  }
}

// world view 0 -> 3
// Country view 4 -> 6
// City view 10 -> 12
// Street view 13 -> 17
// Building view 18 -> 20
