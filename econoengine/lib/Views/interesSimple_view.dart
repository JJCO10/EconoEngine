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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interés Simple'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
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
              const SizedBox(height: 20),
              // Botones para calcular
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _calcularVF,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Calcular VF'),
                  ),
                  ElevatedButton(
                    onPressed: _calcularTasaInteres,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Calcular i'),
                  ),
                  ElevatedButton(
                    onPressed: _calcularTiempo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Calcular t'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Mostrar el resultado
              Text(
                _resultado,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para construir un campo de texto
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }
}