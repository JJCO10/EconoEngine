// lib/Services/settings_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Claves para SharedPreferences
  static const String _isDarkModeKey = 'isDarkMode';
  static const String _isHighContrastKey = 'isHighContrast';
  static const String _textSizeKey = 'textSize';
  // static const String _notificationsEnabledKey = 'notificationsEnabled';

  // Método para guardar el tema oscuro
  Future<void> saveDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDarkMode);
  }

  // Método para cargar el tema oscuro
  Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? false;
  }

  // Método para guardar el alto contraste
  Future<void> saveHighContrast(bool isHighContrast) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isHighContrastKey, isHighContrast);
  }

  // Método para cargar el alto contraste
  Future<bool> loadHighContrast() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isHighContrastKey) ?? false;
  }

  // Método para guardar el tamaño del texto
  Future<void> saveTextSize(double textSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_textSizeKey, textSize);
  }

  // Método para cargar el tamaño del texto
  Future<double> loadTextSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_textSizeKey) ?? 14.0;
  }

  // // Método para guardar el estado de las notificaciones
  // Future<void> saveNotificationsEnabled(bool enabled) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool(_notificationsEnabledKey, enabled);
  // }

  // // Método para cargar el estado de las notificaciones
  // Future<bool> loadNotificationsEnabled() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getBool(_notificationsEnabledKey) ?? true;
  // }
}
