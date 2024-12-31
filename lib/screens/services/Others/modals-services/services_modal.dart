import 'package:flutter/material.dart';
import 'package:zonta/screens/services/Others/glass-Services/map_screen.dart';
import 'service_item.dart';

class ServicesModal extends StatelessWidget {
  const ServicesModal({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600
        ? 4
        : screenWidth < 900
            ? 6
            : 8;
    final itemSize = screenWidth < 600 ? 24.0 : 32.0;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Find Service',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85, // Adjusted for better spacing
              children: [
                ServiceItem(
                    icon: Icons.local_florist,
                    name: 'Flower\nDelivery',
                    color: Colors.blue,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.water_drop,
                    name: 'Water\nDelivery',
                    color: Colors.blue,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.pets,
                    name: 'Dog\nWalking',
                    color: Colors.orange,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.child_care,
                    name: 'Baby Care',
                    color: Colors.orange,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.pets,
                    name: 'Pet Care',
                    color: Colors.orange,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.fitness_center,
                    name: 'Workout\nTrainer',
                    color: Colors.orange,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.security,
                    name: 'Security\nService',
                    color: Colors.orange,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.school,
                    name: 'Tutors',
                    color: Colors.orange,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.spa,
                    name: 'Massage\nService',
                    color: Colors.orange,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.plumbing,
                    name: 'Plumbers',
                    color: Colors.red,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.yard,
                    name: 'Gardening',
                    color: Colors.red,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.ac_unit,
                    name: 'Snow\nBlowers',
                    color: Colors.red,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.local_laundry_service,
                    name: 'Laundry\nService',
                    color: Colors.red,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.cleaning_services,
                    name: 'Maid Service',
                    color: Colors.red,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.pest_control,
                    name: 'Pest Control',
                    color: Colors.red,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.ac_unit,
                    name: 'AC Repair',
                    color: Colors.red,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.track_changes_outlined,
                    name: 'Tow Truck',
                    color: Colors.red,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.local_car_wash,
                    name: 'Car Wash',
                    color: Colors.red,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.electrical_services,
                    name: 'Electricians',
                    color: Colors.red,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.car_repair,
                    name: 'Car repair',
                    color: Colors.red,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.face,
                    name: 'cus rel',
                    color: Colors.orange,
                    size: itemSize),
                ServiceItem(
                    icon: Icons.window,
                    name: 'Glass Genie',
                    color: Colors.black,
                    size: itemSize),
                ServiceItem(
                  imagePath: 'assets/images/zonta_logo.jpg',
                  name: 'Glass Service',
                  color: Colors.black,
                  size: itemSize,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MapScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
