import 'package:shared_preferences/shared_preferences.dart';
import '../Models/theme_model.dart';

class ThemeService {
  // Cargar la preferencia del tema desde SharedPreferences
  Future<ThemeModel> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    return ThemeModel(isDarkMode: isDarkMode);
  }

  // Cambiar el tema y guardar la preferencia
  Future<ThemeModel> toggleTheme(ThemeModel themeModel) async {
    final isDarkMode = !themeModel.isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
    return ThemeModel(isDarkMode: isDarkMode);
  }
}
