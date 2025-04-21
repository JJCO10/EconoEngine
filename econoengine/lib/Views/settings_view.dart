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

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
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
              'Tema',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Tema Oscuro'),
              value: themeController.isDarkMode,
              onChanged: (value) {
                themeController.toggleTheme();
              },
            ),
            const Divider(height: 20),

            // Sección de Idioma
            Text(
              'Idioma',
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
                  child: Text(AppLocalizations.of(context).translate(
                      'spanish')), // Añade 'spanish' a tu diccionario
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text(AppLocalizations.of(context).translate(
                      'english')), // Añade 'english' a tu diccionario
                ),
              ],
            ),
            const Divider(height: 20),

            // Sección de Accesibilidad
            Text(
              'Accesibilidad',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Alto Contraste'),
              value: themeController.isHighContrast,
              onChanged: (value) {
                themeController.setHighContrast(value);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Tamaño del Texto'),
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
              'Información de la Aplicación',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Versión'),
              subtitle: const Text('1.0.0'),
              trailing: IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Acerca de EconoEngine'),
                      content: const SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('EconoEngine versión 1.0.0'),
                            SizedBox(height: 10),
                            Text(
                                'Una aplicación para gestionar tus finanzas de manera eficiente.'),
                            SizedBox(height: 10),
                            Text('© 2025 EconoEngine'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cerrar'),
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
