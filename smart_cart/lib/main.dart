import 'package:flutter/material.dart';
import 'package:smart_cart/features/preferences/preferences_screen.dart';

void main() {
  runApp(const SmartCartApp());
}

class SmartCartApp extends StatelessWidget {
  const SmartCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PreferencesScreen(),
    );
  }
}
