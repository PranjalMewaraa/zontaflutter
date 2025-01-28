import 'package:google_maps_flutter/google_maps_flutter.dart';

class Driver {
  final String id;
  final String name;
  final LatLng position;
  final double price;
  final double rating;
  final String vehicleType;
  final String vehicleNumber;

  Driver({
    required this.id,
    required this.name,
    required this.position,
    required this.price,
    this.rating = 0.0,
    required this.vehicleType,
    required this.vehicleNumber,
  });
}
