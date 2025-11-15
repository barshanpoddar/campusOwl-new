import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// home_screen.dart exists (detailed home content); top-level landing page uses `home_page.dart`
import 'screens/home_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/services_screen.dart';
import 'screens/jobs_screen.dart';
import 'screens/focus_screen.dart';
import 'widgets/custom_fab_button.dart';
import 'widgets/bottom_navigation.dart';
import 'widgets/custom_alert_dialog.dart';
import 'themes.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/no_internet_screen.dart';

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
            '/no-internet': (_) => const NoInternetScreen(),
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

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  late final List<Widget> _screens;
  late final PageController _pageController;
  // Keys to control FABs inside specific screens so we can collapse them when switching tabs
  final GlobalKey<CustomFabButtonState> _notesFabKey = GlobalKey<CustomFabButtonState>();
  final GlobalKey<CustomFabButtonState> _servicesFabKey = GlobalKey<CustomFabButtonState>();
  DateTime? _pausedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Create screens once to avoid rebuilding heavy widgets on each tab change.
    _screens = [
      const HomeScreen(),
      NotesScreen(fabKey: _notesFabKey),
      ServicesScreen(fabKey: _servicesFabKey),
      const JobsScreen(),
      const FocusScreen(),
    ];
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // App is going to background or being closed
      _pausedTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      // App is coming back to foreground
      if (_pausedTime != null) {
        // If app was closed/backgrounded, restart from splash screen
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        }
      }
    }
  }

  Future<bool> _showExitConfirmation() async {
    return await CustomAlertDialog.showConfirmation(
      context: context,
      title: 'Exit App',
      message: 'Are you sure you want to exit CampusOwl?',
      confirmText: 'Exit',
      cancelText: 'Cancel',
      confirmButtonColor: Colors.red,
      icon: Icons.exit_to_app,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmation();
        if (shouldPop && context.mounted) {
          // Exit the app completely
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        // Use IndexedStack to keep off-screen widgets alive and make switching instant.
        body: SafeArea(
          // Use a PageView and animate between pages for a short, snappy transition.
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) => setState(() => _selectedIndex = index),
            children: _screens,
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          currentIndex: _selectedIndex,
          onTap: (index) {
            // collapse any open FABs in screens before switching
            _notesFabKey.currentState?.collapse();
            _servicesFabKey.currentState?.collapse();
            // Update selected index immediately for visual feedback on the nav,
            // then animate the page change with a short duration so the app feels snappy.
            setState(() => _selectedIndex = index);
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
            );
          },
        ),
      ),
    );
  }
}
