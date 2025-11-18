import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CamFishApp());
}

class CamFishApp extends StatelessWidget {
  const CamFishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CamFish',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B70FC)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
