// lib/Views/settings_view.dart
import 'package:econoengine/Controllers/theme_controller.dart';
import 'package:econoengine/Controllers/text_size_controller.dart';
import 'package:econoengine/Controllers/language_controller.dart';
import 'package:econoengine/l10n/app_localizations_setup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // final List<String> _idiomas = ['Español', 'Inglés'];

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final textSizeController = Provider.of<TextSizeController>(context);
    final languageController = Provider.of<LanguageController>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
        backgroundColor: themeController.currentTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Tema
            Text(
              loc.theme,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: Text(loc.darkTheme),
              value: themeController.isDarkMode,
              onChanged: (value) {
                themeController.toggleTheme();
              },
            ),
            const Divider(height: 20),

            // Sección de Idioma
            Text(
              loc.language,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 10),
            // Cambiar el DropdownButtonFormField
            // En el DropdownButtonFormField
            DropdownButtonFormField<String>(
              value: languageController.currentLanguageCode,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  languageController.setLanguage(newValue);
                }
              },
              items: [
                DropdownMenuItem(
                  value: 'es',
                  child: Text(loc.spanish), // Añade 'spanish' a tu diccionario
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text(loc.english), // Añade 'english' a tu diccionario
                ),
              ],
            ),
            const Divider(height: 20),

            // Sección de Accesibilidad
            Text(
              loc.accessibility,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: Text(loc.highContrast),
              value: themeController.isHighContrast,
              onChanged: (value) {
                themeController.setHighContrast(value);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(loc.textSize),
              subtitle: Slider(
                value: textSizeController.textSize,
                min: 12.0,
                max: 24.0,
                divisions: 6,
                label: textSizeController.textSize.toStringAsFixed(1),
                onChanged: (value) {
                  textSizeController.setTextSize(value);
                },
              ),
            ),
            const Divider(height: 20),

            // Sección de Información de la Aplicación
            Text(
              loc.appInfo,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(loc.version),
              subtitle: const Text('2.0.0'),
              trailing: IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(loc.aboutEconoEngine),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(loc.aboutEconoEngineText1),
                            SizedBox(height: 10),
                            Text(loc.aboutEconoEngineText2),
                            SizedBox(height: 10),
                            Text(loc.aboutEconoEngineText3),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(loc.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
