import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// home_screen.dart exists (detailed home content); top-level landing page uses `home_page.dart`
import 'screens/home_page.dart';
import 'screens/notes_screen.dart';
import 'screens/services_screen.dart';
import 'screens/jobs_screen.dart';
import 'screens/focus_screen.dart';
import 'widgets/bottom_navigation.dart';
import 'themes.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const CampusOwlApp(),
    ),
  );
}

class CampusOwlApp extends StatelessWidget {
  const CampusOwlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'CampusOwl',
          theme: appThemeLight,
          darkTheme: appThemeDark,
          themeMode: themeProvider.themeMode,
          // Start with a lightweight splash screen and route to MainPage.
          home: const SplashScreen(),
          routes: {
            '/home': (_) => const MainPage(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomePage(onSelectTab: (i) => setState(() => _selectedIndex = i)),
      NotesScreen(),
      ServicesScreen(),
      JobsScreen(),
      FocusScreen(),
    ];

    return Scaffold(
      body: SafeArea(child: screens[_selectedIndex]),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
