import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  static const String _darkModeKey = 'darkMode';

  AppThemeProvider();

  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs;
    _isDarkMode = _prefs.getBool(_darkModeKey) ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool(_darkModeKey, _isDarkMode);
    notifyListeners();
  }
}
