import 'package:flutter/material.dart';

class RideSearchCard extends StatefulWidget {
  final Function(String, String, String)? onSearch;

  const RideSearchCard({Key? key, this.onSearch}) : super(key: key);

  @override
  _RideSearchCardState createState() => _RideSearchCardState();
}

class _RideSearchCardState extends State<RideSearchCard> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();
  String _selectedVehicle = "Car";

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Card(
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInputField(
                controller: _pickupController,
                hintText: "Pickup Location",
                icon: Icons.location_on,
              ),
              const SizedBox(height: 8),
              _buildInputField(
                controller: _dropoffController,
                hintText: "Drop-off Location",
                icon: Icons.place,
              ),
              const SizedBox(height: 16),
              _buildVehicleOptions(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (widget.onSearch != null) {
                    widget.onSearch!(
                      _pickupController.text,
                      _dropoffController.text,
                      _selectedVehicle,
                    );
                  }
                },
                child: const Text("Search Ride"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildVehicleOptions() {
    final vehicleOptions = ["Car", "Limousine", "Bike"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: vehicleOptions.map((vehicle) {
        final isSelected = vehicle == _selectedVehicle;
        return ChoiceChip(
          label: Text(vehicle),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _selectedVehicle = vehicle;
              });
            }
          },
          selectedColor: Colors.blue,
          backgroundColor: Colors.grey[200],
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        );
      }).toList(),
    );
  }
}
