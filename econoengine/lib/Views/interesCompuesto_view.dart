import 'dart:math';

import 'package:flutter/material.dart';

class InteresCompuestoView extends StatefulWidget {
  const InteresCompuestoView({super.key});

  @override
  State<InteresCompuestoView> createState() => _InteresCompuestoViewState();
}

class _InteresCompuestoViewState extends State<InteresCompuestoView> {
  // Controladores para los campos de texto
  final TextEditingController _cController = TextEditingController(); // Capital inicial (C)
  final TextEditingController _mcController = TextEditingController(); // Monto Compuesto (MC)
  final TextEditingController _iController = TextEditingController(); // Tasa de interés (i)
  final TextEditingController _nController = TextEditingController(); // Tiempo (n)

  // Variable para almacenar el resultado
  String _resultado = '';

  // Método para verificar si un campo debe estar deshabilitado
  bool _shouldDisableField(TextEditingController controller) {
    int filledFields = 0;
    if (_cController.text.isNotEmpty) filledFields++;
    if (_mcController.text.isNotEmpty) filledFields++;
    if (_iController.text.isNotEmpty) filledFields++;
    if (_nController.text.isNotEmpty) filledFields++;

    // Si hay 3 campos llenos, deshabilitar el cuarto
    return filledFields == 3 && controller.text.isEmpty;
  }

  // Método para calcular el Monto Compuesto (MC)
  void _calcularMC() {
    double c = double.tryParse(_cController.text) ?? 0;
    double i = double.tryParse(_iController.text) ?? 0;
    double n = double.tryParse(_nController.text) ?? 0;

    if (c <= 0 || i <= 0 || n <= 0) {
      setState(() {
        _resultado = 'Por favor, ingrese valores válidos para C, i y n.';
      });
      return;
    }

    double mc = c * pow(1 + (i / 100), n); // Convertir i a decimal
    setState(() {
      _resultado = 'Monto Compuesto (MC): \$${mc.toStringAsFixed(2)}';
    });
  }

  // Método para calcular el Tiempo (n)
  void _calcularN() {
    double c = double.tryParse(_cController.text) ?? 0;
    double mc = double.tryParse(_mcController.text) ?? 0;
    double i = double.tryParse(_iController.text) ?? 0;

    if (c <= 0 || mc <= 0 || i <= 0) {
      setState(() {
        _resultado = 'Por favor, ingrese valores válidos para C, MC y i.';
      });
      return;
    }

    double n = (log(mc) - log(c)) / log(1 + (i / 100)); // Convertir i a decimal
    setState(() {
      _resultado = 'Tiempo (n): ${n.toStringAsFixed(2)} años';
    });
  }

  // Método para calcular la Tasa de Interés (i)
  void _calcularI() {
    double c = double.tryParse(_cController.text) ?? 0;
    double mc = double.tryParse(_mcController.text) ?? 0;
    double n = double.tryParse(_nController.text) ?? 0;

    if (c <= 0 || mc <= 0 || n <= 0) {
      setState(() {
        _resultado = 'Por favor, ingrese valores válidos para C, MC y n.';
      });
      return;
    }

    double i = (pow(mc / c, 1 / n) - 1) * 100; // Convertir a porcentaje
    setState(() {
      _resultado = 'Tasa de Interés (i): ${i.toStringAsFixed(2)}%';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interés Compuesto'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para Capital Inicial (C)
              _buildTextField(
                'Capital Inicial (C)',
                _cController,
                hintText: "Ej: 1000",
                suffixText: "\$",
              ),
              const SizedBox(height: 20),
              // Campo para Monto Compuesto (MC)
              _buildTextField(
                'Monto Compuesto (MC)',
                _mcController,
                hintText: "Ej: 2000",
                suffixText: "\$",
              ),
              const SizedBox(height: 20),
              // Campo para Tasa de Interés (i)
              _buildTextField(
                'Tasa de Interés (i)',
                _iController,
                hintText: "Ej: 12 (para 12%)",
                suffixText: "%",
              ),
              const SizedBox(height: 20),
              // Campo para Tiempo (n)
              _buildTextField(
                'Tiempo (n)',
                _nController,
                hintText: "Ej: 5 (años)",
                suffixText: "años",
              ),
              const SizedBox(height: 30),
              // Botones para calcular
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      'Calcular MC',
                      Colors.blue[800]!,
                      _calcularMC,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildButton(
                      'Calcular n',
                      Colors.green[800]!,
                      _calcularN,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildButton(
                      'Calcular i',
                      Colors.orange[800]!,
                      _calcularI,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Mostrar el resultado
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  _resultado,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir un campo de texto con estilo
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hintText,
    String? suffixText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        suffixText: suffixText,
        labelStyle: TextStyle(
          color: Colors.blue[800],
          fontWeight: FontWeight.bold,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
        ),
        enabled: !_shouldDisableField(controller), // Deshabilitar si es necesario
      ),
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
      onChanged: (value) {
        // Actualizar el estado cuando el usuario ingresa un valor
        setState(() {});
      },
    );
  }

  // Método para construir un botón con estilo
  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}