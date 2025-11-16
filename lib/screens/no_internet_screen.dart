import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../widgets/app_icon.dart';
import 'splash_screen.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool _checking = false;

  Future<void> _retry() async {
    setState(() => _checking = true);
    final hasConnection = await InternetConnectionChecker().hasConnection;
    if (!mounted) return;
    if (hasConnection) {
      // Go back to the splash screen so it can run the normal startup flow
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SplashScreen()),
      );
    } else {
      setState(() => _checking = false);
      // stay on screen; maybe show a small SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Still no internet connection')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0A3D91), // same royal blue
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppIcon(assetName: 'x_mark', size: 96, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                'No internet connection',
                style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your connection and try again.',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: _checking ? null : _retry,
        icon: _checking
          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
          : const AppIcon(assetName: 'arrow_path', size: 18, color: Color(0xFF0A3D91)),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0A3D91),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
