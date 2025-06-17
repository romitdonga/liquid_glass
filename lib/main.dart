import 'package:flutter/material.dart';
import 'package:liquid_glass_demo/dashboard_page.dart';

/// The main entry point of the application
void main() {
  runApp(const MyApp());
}

/// The root widget of the application
///
/// This widget configures the app's theme and sets up the MaterialApp
/// with the DashboardPage as the home screen.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Glass Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}
