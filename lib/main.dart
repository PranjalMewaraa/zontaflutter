import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:provider/provider.dart';
import 'screens/splashScreen/spalsh_screen.dart';
import 'provider/preferences_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PreferencesProvider(),
      child: const ZontaApp(),
    ),
  );
}

class ZontaApp extends StatelessWidget {
  const ZontaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Use GetMaterialApp instead of MaterialApp
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'Zonta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter',
      ),
      home: const SplashScreen(),
    );
  }
}
