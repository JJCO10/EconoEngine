// lib/Controllers/language_controller.dart
import 'package:flutter/material.dart';
import 'package:econoengine/Services/settings_service.dart';

class LanguageController extends ChangeNotifier {
  final SettingsService _settingsService =
      SettingsService(); // Declara el servicio
  Locale _currentLocale = const Locale('es', 'ES');

  Locale get currentLocale => _currentLocale;
  String get currentLanguageCode => _currentLocale.languageCode;

  Future<void> setLanguage(String languageCode) async {
    if (!['es', 'en'].contains(languageCode)) return;

    _currentLocale = Locale(languageCode);
    await _settingsService.saveLanguage(languageCode);
    notifyListeners(); // Esto es crucial para reconstruir la UI
  }

  Future<void> loadSelectedLanguage() async {
    final savedLang = await _settingsService.loadLanguage();
    _currentLocale = Locale(savedLang);
    notifyListeners();
  }
}
