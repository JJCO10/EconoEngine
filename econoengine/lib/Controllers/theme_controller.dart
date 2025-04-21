// lib/Controllers/theme_controller.dart
import 'package:flutter/material.dart';
import 'package:econoengine/Services/settings_service.dart';

class ThemeController extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();
  bool _isDarkMode = false;
  bool _isHighContrast = false;

  ThemeController();

  Future<void> init() async {
    _isDarkMode = await _settingsService.loadDarkMode();
    _isHighContrast = await _settingsService.loadHighContrast();
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;
  bool get isHighContrast => _isHighContrast;

  ThemeData get currentTheme {
    if (_isDarkMode) {
      return _isHighContrast ? _darkHighContrastTheme : _darkTheme;
    } else {
      return _isHighContrast ? _lightHighContrastTheme : _lightTheme;
    }
  }

  // Tema claro normal
  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    useMaterial3: true,
    // Más configuraciones del tema...
  );

  // Tema oscuro normal
  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue.shade700,
    useMaterial3: true,
    // Más configuraciones del tema...
  );

  // Tema claro de alto contraste
  final ThemeData _lightHighContrastTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    useMaterial3: true,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    // Más configuraciones para alto contraste...
  );

  // Tema oscuro de alto contraste
  final ThemeData _darkHighContrastTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.black,
    useMaterial3: true,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    // Más configuraciones para alto contraste...
  );

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _settingsService.saveDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> setHighContrast(bool value) async {
    _isHighContrast = value;
    await _settingsService.saveHighContrast(_isHighContrast);
    notifyListeners();
  }
}
