import 'package:flutter/material.dart';
import '../Models/theme_model.dart';
import '../Services/theme_service.dart';

class ThemeController with ChangeNotifier {
  final ThemeService _themeService = ThemeService();
  ThemeModel _themeModel = ThemeModel(isDarkMode: false);

  bool get isDarkMode => _themeModel.isDarkMode;

  ThemeController() {
    _loadThemePreference();
  }

  // Cargar la preferencia del tema desde SharedPreferences
  Future<void> _loadThemePreference() async {
    _themeModel = await _themeService.loadThemePreference();
    notifyListeners();
  }

  // Cambiar el tema y guardar la preferencia
  Future<void> toggleTheme() async {
    _themeModel = await _themeService.toggleTheme(_themeModel);
    notifyListeners();
  }

  ThemeData get currentTheme =>
      _themeModel.isDarkMode ? _darkTheme : _lightTheme;

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue[800],
    colorScheme: ColorScheme.light(
      primary: Colors.blue[800]!,
      secondary: Colors.blue[600]!,
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue[800],
    colorScheme: ColorScheme.dark(
      primary: Colors.blue[800]!,
      secondary: Colors.blue[600]!,
    ),
  );
}
