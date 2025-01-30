import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:provider/provider.dart';
import 'package:zonta/features/auto_service/data/repositories/location_repository.dart';
import 'package:zonta/features/auto_service/presentation/bloc/location_bloc.dart';
import 'package:zonta/features/auto_service/presentation/bloc/ride_bloc.dart';
import 'screens/splashScreen/spalsh_screen.dart';
import 'provider/preferences_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(),
        ),
        Provider<LocationRepository>(
          create: (_) => LocationRepository(),
        ),
        Provider<LocationBloc>(
          create: (context) => LocationBloc(
            context.read<LocationRepository>(), // Pass the repository here
          ),
          dispose: (_, bloc) => bloc.close(),
        ),
        Provider<RideBloc>(
          create: (_) => RideBloc(),
          dispose: (_, bloc) => bloc.close(),
        ),
      ],
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
