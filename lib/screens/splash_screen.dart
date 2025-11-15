import 'dart:async';

import 'package:flutter/material.dart';
import '../widgets/app_icon.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After a short delay navigate to the main app route.
    Timer(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A3D91), // royal blue
      body: Center(
        // Use AppIcon to prefer an SVG asset named `owl.svg` (or fallback to Icon)
        child: AppIcon(assetName: 'owl', size: 120, color: Colors.white),
      ),
    );
  }
}
