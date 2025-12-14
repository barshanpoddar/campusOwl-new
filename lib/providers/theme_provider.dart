import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  DateTime? _lastThemeChangeDate;

  ThemeMode get themeMode => _themeMode;
  DateTime? get lastThemeChangeDate => _lastThemeChangeDate;

  ThemeProvider() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getInt('themeMode');
    if (stored != null && stored >= 0 && stored < ThemeMode.values.length) {
      _themeMode = ThemeMode.values[stored];
    } else {
      // Default to light theme when there's no stored preference.
      _themeMode = ThemeMode.light;
    }

    // Load the last theme change date
    final storedDate = prefs.getString('themeChangeDate');
    if (storedDate != null) {
      _lastThemeChangeDate = DateTime.parse(storedDate);
    }

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _lastThemeChangeDate = DateTime.now();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', _themeMode.index);
    await prefs.setString(
        'themeChangeDate', _lastThemeChangeDate!.toIso8601String());

    notifyListeners();
  }
}
