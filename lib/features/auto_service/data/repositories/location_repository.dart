import 'package:geolocator/geolocator.dart';
import '../../domain/repositories/i_location_repository.dart';

class LocationRepository implements ILocationRepository {
  LocationRepository();

  @override
  Future<Position> getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions denied');
    }
    return Geolocator.getCurrentPosition();
  }

  @override
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream();
  }
}
