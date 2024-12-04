import 'package:flutter/material.dart';

class CreditCard extends StatelessWidget {
  const CreditCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Set responsive height and padding
    double cardHeight = screenHeight * 0.25; // 25% of screen height
    double cardPadding = screenWidth * 0.05; // 5% of screen width

    return Container(
      width: double.infinity,
      height: cardHeight, // Responsive height
      padding: EdgeInsets.all(cardPadding), // Responsive padding
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage('assets/images/home/homecard.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
