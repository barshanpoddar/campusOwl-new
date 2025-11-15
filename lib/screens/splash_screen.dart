import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../widgets/app_icon.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // After a short delay, check internet connectivity and navigate accordingly.
    Timer(const Duration(milliseconds: 800), () async {
      if (!mounted) return;
      final hasConnection = await InternetConnectionChecker().hasConnection;
      if (!mounted) return;
      if (hasConnection) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/no-internet');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0A3D91), // royal blue
      body: Center(
        child: AppIcon(assetName: 'Owl_icon', size: 120, color: Colors.white),
      ),
    );
  }
}
