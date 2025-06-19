import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng latLng;
  final String? address;

  PlaceModel({
    required this.id,
    required this.name,
    required this.latLng,
    this.address,
  });
  static List<PlaceModel> places = [
    PlaceModel(
      id: 1,
      name: 'Mall of Arabia',
      latLng: const LatLng(31.23421656831209, 29.950389241391255),
    ),
    PlaceModel(
      id: 2,
      name: 'مطرانية الشهيد العظيم مارجرجس بسوهاج إيبارشيه سوهاج و المنشاة و المراغة',
      latLng: const LatLng(26.558263335989626, 31.69524309564494),
    ),
    PlaceModel(
      id: 3,
      name: '15 Street',
      latLng: const LatLng(26.56469481303887, 31.69403021147461),
    ),
  ];
}
