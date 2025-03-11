import 'package:flutter/material.dart';

class InteresSimpleView extends StatefulWidget {
  const InteresSimpleView({super.key});

  @override
  State<InteresSimpleView> createState() => _InteresSimpleViewState();
}

class _InteresSimpleViewState extends State<InteresSimpleView> {
  // Controladores para los campos de texto
  final TextEditingController _vpController = TextEditingController();
  final TextEditingController _vfController = TextEditingController();
  final TextEditingController _iController = TextEditingController();
  final TextEditingController _tController = TextEditingController();

  // Variable para almacenar el resultado
  String _resultado = '';

  // Método para verificar si un campo debe estar deshabilitado
  bool _shouldDisableField(TextEditingController controller) {
    int filledFields = 0;
    if (_vpController.text.isNotEmpty) filledFields++;
    if (_vfController.text.isNotEmpty) filledFields++;
    if (_iController.text.isNotEmpty) filledFields++;
    if (_tController.text.isNotEmpty) filledFields++;

    // Si hay 3 campos llenos, deshabilitar el cuarto
    return filledFields == 3 && controller.text.isEmpty;
  }

  // Método para calcular el Monto Futuro (VF)
  void _calcularVF() {
    double vp = double.tryParse(_vpController.text) ?? 0;
    double i = double.tryParse(_iController.text) ?? 0;
    double t = double.tryParse(_tController.text) ?? 0;

    if (vp <= 0 || i <= 0 || t <= 0) {
      setState(() {
        _resultado = 'Por favor, ingrese valores válidos para VP, i y t.';
      });
      return;
    }

    double vf = vp * (1 + i * t);
    setState(() {
      _resultado = 'Monto Futuro (VF): \$${vf.toStringAsFixed(2)}';
    });
  }

  // Método para calcular la Tasa de Interés (i)
  void _calcularTasaInteres() {
    double vp = double.tryParse(_vpController.text) ?? 0;
    double vf = double.tryParse(_vfController.text) ?? 0;
    double t = double.tryParse(_tController.text) ?? 0;

    if (vp <= 0 || vf <= 0 || t <= 0) {
      setState(() {
        _resultado = 'Por favor, ingrese valores válidos para VP, VF y t.';
      });
      return;
    }

    double i = ((vf / vp) - 1) / t;
    setState(() {
      _resultado = 'Tasa de Interés (i): ${(i * 100).toStringAsFixed(2)}%';
    });
  }

  // Método para calcular el Tiempo (t)
  void _calcularTiempo() {
    double vp = double.tryParse(_vpController.text) ?? 0;
    double vf = double.tryParse(_vfController.text) ?? 0;
    double i = double.tryParse(_iController.text) ?? 0;

    if (vp <= 0 || vf <= 0 || i <= 0) {
      setState(() {
        _resultado = 'Por favor, ingrese valores válidos para VP, VF y i.';
      });
      return;
    }

    double t = ((vf / vp) - 1) / i;
    setState(() {
      _resultado = 'Tiempo (t): ${t.toStringAsFixed(2)} años';
    });
  }

  // Método para calcular el Valor Presente (VP)
  void _calcularVP() {
    double vf = double.tryParse(_vfController.text) ?? 0;
    double i = double.tryParse(_iController.text) ?? 0;
    double t = double.tryParse(_tController.text) ?? 0;

    if (vf <= 0 || i <= 0 || t <= 0) {
      setState(() {
        _resultado = 'Por favor, ingrese valores válidos para VF, i y t.';
      });
      return;
    }

    double vp = vf / (1 + i * t);
    setState(() {
      _resultado = 'Valor Presente (VP): \$${vp.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interés Simple'),
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
              // Campo para Valor Presente (VP)
              _buildTextField('Valor Presente (VP)', _vpController),
              const SizedBox(height: 20),
              // Campo para Valor Futuro (VF)
              _buildTextField('Valor Futuro (VF)', _vfController),
              const SizedBox(height: 20),
              // Campo para Tasa de Interés (i)
              _buildTextField('Tasa de Interés (i)', _iController),
              const SizedBox(height: 20),
              // Campo para Tiempo (t)
              _buildTextField('Tiempo (t)', _tController),
              const SizedBox(height: 30),
              // Botones para calcular (organizados en 2 filas de 2 botones)
              Column(
                children: [
                  // Primera fila de botones
                  Row(
                    children: [
                      Expanded(
                        child: _buildButton(
                          'Calcular VF',
                          Colors.blue[800]!,
                          _calcularVF,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildButton(
                          'Calcular VP',
                          Colors.purple[800]!,
                          _calcularVP,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Segunda fila de botones
                  Row(
                    children: [
                      Expanded(
                        child: _buildButton(
                          'Calcular i',
                          Colors.green[800]!,
                          _calcularTasaInteres,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildButton(
                          'Calcular t',
                          Colors.orange[800]!,
                          _calcularTiempo,
                        ),
                      ),
                    ],
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
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
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