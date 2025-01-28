import 'package:geolocator/geolocator.dart';

abstract class ILocationRepository {
  Future<Position> getCurrentLocation();
  Stream<Position> getLocationStream();
}
