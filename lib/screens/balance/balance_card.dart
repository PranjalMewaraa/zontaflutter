import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Set responsive padding and font sizes
    double cardPadding = screenWidth * 0.05; // 5% of screen width
    double textFontSize = screenWidth * 0.04; // Font size based on screen width
    double iconSize = screenWidth * 0.1; // Icon size based on screen width
    double spacing = screenWidth * 0.05; // Space between elements

    return Container(
      padding: EdgeInsets.all(cardPadding), // Responsive padding
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Balance',
                style:
                    TextStyle(fontSize: textFontSize), // Responsive text size
              ),
              SizedBox(height: screenHeight * 0.02), // Responsive space
              Text(
                '\$ 0.00',
                style: TextStyle(
                  fontSize: screenWidth * 0.07, // Larger font size for balance
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // Right side buttons (Add Money, Money Transfer)
          Row(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                        iconSize * 0.3), // Responsive icon padding
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: iconSize, // Responsive icon size
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02), // Responsive space
                  Text(
                    'Add\nMoney',
                    style: TextStyle(
                        fontSize: textFontSize), // Responsive text size
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(width: spacing), // Space between the two buttons
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                        iconSize * 0.3), // Responsive icon padding
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.swap_horiz,
                      color: Colors.white,
                      size: iconSize, // Responsive icon size
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02), // Responsive space
                  Text(
                    'Money\nTransfer',
                    style: TextStyle(
                        fontSize: textFontSize), // Responsive text size
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
