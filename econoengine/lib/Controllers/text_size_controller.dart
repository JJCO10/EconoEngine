// lib/Controllers/text_size_controller.dart
import 'package:econoengine/Services/settings_service.dart';
import 'package:flutter/material.dart';

class TextSizeController extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();
  double _textSize = 14.0;

  TextSizeController();

  Future<void> init() async {
    _textSize = await _settingsService.loadTextSize();
    notifyListeners();
  }

  double get textSize => _textSize;

  Future<void> setTextSize(double size) async {
    _textSize = size;
    await _settingsService.saveTextSize(_textSize);
    notifyListeners();
  }

  /// Método para obtener un TextTheme ajustado según el tamaño de texto
  TextTheme getAdjustedTextTheme(TextTheme baseTheme) {
    double factor = _textSize / 14.0;

    return baseTheme.copyWith(
      displayLarge: baseTheme.displayLarge?.copyWith(fontSize: 57 * factor),
      displayMedium: baseTheme.displayMedium?.copyWith(fontSize: 45 * factor),
      displaySmall: baseTheme.displaySmall?.copyWith(fontSize: 36 * factor),
      headlineLarge: baseTheme.headlineLarge?.copyWith(fontSize: 32 * factor),
      headlineMedium: baseTheme.headlineMedium?.copyWith(fontSize: 28 * factor),
      headlineSmall: baseTheme.headlineSmall?.copyWith(fontSize: 24 * factor),
      titleLarge: baseTheme.titleLarge?.copyWith(fontSize: 22 * factor),
      titleMedium: baseTheme.titleMedium?.copyWith(fontSize: 16 * factor),
      titleSmall: baseTheme.titleSmall?.copyWith(fontSize: 14 * factor),
      bodyLarge: baseTheme.bodyLarge?.copyWith(fontSize: 16 * factor),
      bodyMedium: baseTheme.bodyMedium?.copyWith(fontSize: 14 * factor),
      bodySmall: baseTheme.bodySmall?.copyWith(fontSize: 12 * factor),
      labelLarge: baseTheme.labelLarge?.copyWith(fontSize: 14 * factor),
      labelMedium: baseTheme.labelMedium?.copyWith(fontSize: 12 * factor),
      labelSmall: baseTheme.labelSmall?.copyWith(fontSize: 11 * factor),
    );
  }
}
