import 'package:flutter/material.dart';
import '../../domain/entities/driver.dart';

class RouteInfoBottomSheet extends StatelessWidget {
  final double distance;
  final Duration duration;
  final double cost;
  final List<Driver> drivers;
  final Function(Driver) onDriverSelected;

  const RouteInfoBottomSheet({
    Key? key,
    required this.distance,
    required this.duration,
    required this.cost,
    required this.drivers,
    required this.onDriverSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTripDetails(),
          const SizedBox(height: 16),
          _buildDriversList(),
        ],
      ),
    );
  }

  Widget _buildTripDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trip Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildDetailRow(Icons.route, 'Distance',
            '${(distance / 1000).toStringAsFixed(1)} km'),
        _buildDetailRow(Icons.timer, 'Duration', '${duration.inMinutes} mins'),
        _buildDetailRow(Icons.attach_money, 'Estimated Cost',
            '\$${cost.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDriversList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Drivers',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: drivers.length,
          itemBuilder: (context, index) {
            final driver = drivers[index];
            return Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: Text(driver.name),
                subtitle:
                    Text('${driver.vehicleType} - ${driver.vehicleNumber}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${driver.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        Text('${driver.rating}'),
                      ],
                    ),
                  ],
                ),
                onTap: () => onDriverSelected(driver),
              ),
            );
          },
        ),
      ],
    );
  }
}
