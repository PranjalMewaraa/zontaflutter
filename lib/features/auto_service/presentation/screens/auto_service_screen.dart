import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zonta/features/auto_service/presentation/widgets/search_bar.dart';
import '../bloc/location_bloc.dart';
import '../bloc/ride_bloc.dart';
import '../widgets/route_info_bottom_sheet.dart';
import '../../domain/entities/driver.dart';
import '../../data/services/google_map_service.dart';

class AutoServiceScreen extends StatefulWidget {
  const AutoServiceScreen({Key? key}) : super(key: key);

  @override
  State<AutoServiceScreen> createState() => _AutoServiceScreenState();
}

class _AutoServiceScreenState extends State<AutoServiceScreen>
    with TickerProviderStateMixin {
  late GoogleMapController _mapController;
  late AnimationController _markerAnimationController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _startPosition;
  LatLng? _endPosition;
  List<Driver> _nearbyDrivers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeLocation();
  }

  void _initializeControllers() {
    _markerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _markerAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _markerAnimationController.repeat();
      }
    });
  }

  Future<void> _initializeLocation() async {
    context.read<LocationBloc>().add(InitializeLocation());
  }

  @override
  void dispose() {
    _markerAnimationController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _updateMapPosition(LatLng position) async {
    final CameraPosition newPosition = CameraPosition(
      target: position,
      zoom: 15,
    );
    await _mapController
        .animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  void _fetchNearbyDrivers(LatLng position) {
    // Simulate fetching nearby drivers
    // In a real app, this would be an API call
    _nearbyDrivers = [
      Driver(
        id: '1',
        name: 'John Doe',
        position: LatLng(
          position.latitude + 0.001,
          position.longitude + 0.001,
        ),
        price: 25.0,
        vehicleType: 'Sedan',
        vehicleNumber: 'ABC123',
        rating: 4.8,
      ),
      Driver(
        id: '2',
        name: 'Jane Smith',
        position: LatLng(
          position.latitude - 0.001,
          position.longitude - 0.001,
        ),
        price: 22.0,
        vehicleType: 'SUV',
        vehicleNumber: 'XYZ789',
        rating: 4.9,
      ),
    ];
    _updateDriverMarkers();
  }

  void _updateDriverMarkers() {
    setState(() {
      _markers
          .removeWhere((marker) => marker.markerId.value.startsWith('driver_'));

      for (final driver in _nearbyDrivers) {
        _markers.add(
          Marker(
            markerId: MarkerId('driver_${driver.id}'),
            position: driver.position,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow),
            infoWindow: InfoWindow(
              title: '${driver.name} - ${driver.vehicleType}',
              snippet:
                  '\$${driver.price.toStringAsFixed(2)} • ${driver.rating} ⭐',
            ),
          ),
        );
      }
    });
  }

  Future<void> _drawRoute() async {
    if (_startPosition == null || _endPosition == null) return;

    setState(() => _isLoading = true);

    try {
      final directions = await GoogleMapsService(
        apiKey: 'YOUR_GOOGLE_MAPS_API_KEY',
      ).getDirections(
        origin: _startPosition!,
        destination: _endPosition!,
      );

      final points = await GoogleMapsService(
        apiKey: 'YOUR_GOOGLE_MAPS_API_KEY',
      ).decodePolyline(directions['routes'][0]['overview_polyline']['points']);

      final bounds = LatLngBounds(
        southwest: LatLng(
          directions['routes'][0]['bounds']['southwest']['lat'],
          directions['routes'][0]['bounds']['southwest']['lng'],
        ),
        northeast: LatLng(
          directions['routes'][0]['bounds']['northeast']['lat'],
          directions['routes'][0]['bounds']['northeast']['lng'],
        ),
      );

      setState(() {
        _polylines.clear();
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 5,
          ),
        );
      });

      await _mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );

      final distance =
          directions['routes'][0]['legs'][0]['distance']['value'].toDouble();
      final duration = Duration(
        seconds: directions['routes'][0]['legs'][0]['duration']['value'],
      );

      _showRouteInfo(distance, duration);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting directions: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showRouteInfo(double distance, Duration duration) {
    final cost = _calculateCost(distance);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.8,
        builder: (_, controller) => RouteInfoBottomSheet(
          distance: distance,
          duration: duration,
          cost: cost,
          drivers: _nearbyDrivers,
          onDriverSelected: (driver) {
            context.read<RideBloc>().add(RequestRide(driver));
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  double _calculateCost(double distanceInMeters) {
    const basePrice = 5.0;
    const pricePerKm = 2.0;
    return basePrice + (distanceInMeters / 1000 * pricePerKm);
  }

  void _handleMapTap(LatLng position) {
    if (_startPosition == null) {
      setState(() {
        _startPosition = position;
        _markers.add(
          Marker(
            markerId: const MarkerId('start'),
            position: position,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            infoWindow: const InfoWindow(title: 'Start Location'),
          ),
        );
      });
    } else if (_endPosition == null) {
      setState(() {
        _endPosition = position;
        _markers.add(
          Marker(
            markerId: const MarkerId('end'),
            position: position,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: const InfoWindow(title: 'Destination'),
          ),
        );
      });
      _drawRoute();
    }
  }

  void _resetRoute() {
    setState(() {
      _startPosition = null;
      _endPosition = null;
      _markers.clear();
      _polylines.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildTopControls(),
          if (_isLoading) _buildLoadingIndicator(),
          _buildRideStateHandler(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(),
    );
  }

  Widget _buildMap() {
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationUpdated) {
          _updateMapPosition(state.position);
          _fetchNearbyDrivers(state.position);
        }
      },
      child: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 15,
        ),
        onMapCreated: (controller) => _mapController = controller,
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onTap: _handleMapTap,
      ),
    );
  }

  Widget _buildTopControls() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchBar(
              onSearch: (query) {
                // Implement location search
                // This would typically use the Google Places API
              },
            ),
            const SizedBox(height: 16),
            _buildCurrentLocation(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocation() {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        if (state is LocationUpdated) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Current Location: ${state.position.latitude.toStringAsFixed(4)}, '
                  '${state.position.longitude.toStringAsFixed(4)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildRideStateHandler() {
    return BlocListener<RideBloc, RideState>(
      listener: (context, state) {
        if (state is RideAccepted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ride accepted by ${state.driver.name}!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is RideError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: const SizedBox.shrink(),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {
            if (context.read<LocationBloc>().state is LocationUpdated) {
              final state =
                  context.read<LocationBloc>().state as LocationUpdated;
              _mapController.animateCamera(
                CameraUpdate.newLatLng(state.position),
              );
            }
          },
          heroTag: 'locate',
          child: const Icon(Icons.my_location),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: _resetRoute,
          heroTag: 'reset',
          child: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
