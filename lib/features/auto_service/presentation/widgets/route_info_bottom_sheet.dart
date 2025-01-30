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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTripDetails(),
            const SizedBox(height: 16),
            _buildDriversList(),
          ],
        ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
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
            return _buildDriverCard(driver);
          },
        ),
      ],
    );
  }

  Widget _buildDriverCard(Driver driver) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.withOpacity(0.2),
          child: const Icon(Icons.person, color: Colors.blueAccent),
        ),
        title: Text(
          driver.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${driver.vehicleType} - ${driver.vehicleNumber}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${driver.price.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                Text(
                  driver.rating.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        onTap: () => onDriverSelected(driver),
      ),
    );
  }
}
