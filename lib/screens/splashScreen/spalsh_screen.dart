import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences
import 'package:zonta/screens/dashboard/dashboard_screen.dart'; // Your Dashboard screen
import 'package:zonta/screens/preference/preference_screen.dart'; // Your Preference screen
import 'package:zonta/provider/preferences_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  // Method to check user preferences and navigate accordingly
  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(
        seconds: 2)); // Wait for a while to show the splash screen
    if (!mounted) return;

    final prefs = Provider.of<PreferencesProvider>(context, listen: false);

    // Check for the user_id in SharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? userId = sharedPreferences
        .getInt('user_id'); // Fetch user_id from SharedPreferences

    if (userId != null) {
      // If user_id exists, navigate to DashboardScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      // If no user_id, navigate to PreferencesScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PreferencesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/zonta_logo.jpg', // Adjust the logo path
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              'ZONTA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 350),
            const Text(
              'V1.0.0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
