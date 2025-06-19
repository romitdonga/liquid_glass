import 'package:flutter/material.dart';
import 'package:liquid_glass_demo/main_navigation.dart';

/// Main entry point of the application
void main() => runApp(const MyApp());

/// Root widget configuring app theme and MainNavigation as home screen
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Glass',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MainNavigation(),
    );
  }
}
