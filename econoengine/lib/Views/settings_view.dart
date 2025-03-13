import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // Variables para almacenar las preferencias del usuario
  bool _notificacionesHabilitadas = true;
  bool _temaOscuro = false;
  String _idiomaSeleccionado = 'Español';
  bool _altoContraste = false;
  double _tamanoTexto = 14.0; // Tamaño de texto base

  // Lista de idiomas disponibles
  final List<String> _idiomas = ['Español', 'Inglés', 'Francés', 'Alemán'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.blue[800],
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
              value: _temaOscuro,
              onChanged: (value) {
                setState(() {
                  _temaOscuro = value;
                });
                // Aquí puedes agregar la lógica para cambiar el tema de la aplicación
              },
            ),
            const Divider(height: 20),
            // Sección de Notificaciones
            Text(
              'Notificaciones',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text('Habilitar Notificaciones'),
              value: _notificacionesHabilitadas,
              onChanged: (value) {
                setState(() {
                  _notificacionesHabilitadas = value;
                });
                // Aquí puedes agregar la lógica para habilitar/deshabilitar notificaciones
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
            DropdownButtonFormField<String>(
              value: _idiomaSeleccionado,
              onChanged: (String? newValue) {
                setState(() {
                  _idiomaSeleccionado = newValue!;
                });
                // Aquí puedes agregar la lógica para cambiar el idioma de la aplicación
              },
              items: _idiomas.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
              value: _altoContraste,
              onChanged: (value) {
                setState(() {
                  _altoContraste = value;
                });
                // Aquí puedes agregar la lógica para aplicar el modo de alto contraste
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Tamaño del Texto'),
              subtitle: Slider(
                value: _tamanoTexto,
                min: 12.0,
                max: 24.0,
                divisions: 6,
                label: _tamanoTexto.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _tamanoTexto = value;
                  });
                  // Aquí puedes agregar la lógica para ajustar el tamaño del texto
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
                  // Aquí puedes agregar la lógica para mostrar más detalles
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}