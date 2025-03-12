import 'package:flutter/material.dart';
import 'dart:math';

class GradientesView extends StatefulWidget {
  const GradientesView({super.key});

  @override
  State<GradientesView> createState() => _GradientesViewState();
}

class _GradientesViewState extends State<GradientesView> {
  // Controladores para los campos de texto
  final TextEditingController _serieController = TextEditingController(); // Valor de la serie
  final TextEditingController _gradienteController = TextEditingController(); // Valor del gradiente
  final TextEditingController _tasaController = TextEditingController(); // Tasa de interés
  final TextEditingController _periodosController = TextEditingController(); // Número de periodos
  final TextEditingController _vpController = TextEditingController(); // Valor presente
  final TextEditingController _vfController = TextEditingController(); // Valor futuro

  // Variables para almacenar los resultados
  String _tipoGradiente = 'Aritmético'; // Tipo de gradiente seleccionado
  String _resultado = ''; // Resultado del cálculo

  // Método para calcular el valor presente o futuro
  void _calcular() {
    double serie = double.tryParse(_serieController.text) ?? 0;
    double gradiente = double.tryParse(_gradienteController.text) ?? 0;
    double tasa = double.tryParse(_tasaController.text) ?? 0;
    int periodos = int.tryParse(_periodosController.text) ?? 0;
    double vp = double.tryParse(_vpController.text) ?? 0;
    double vf = double.tryParse(_vfController.text) ?? 0;

    if (tasa <= 0 || periodos <= 0) {
      setState(() {
        _resultado = 'Por favor, ingrese valores válidos para la tasa y los periodos.';
      });
      return;
    }

    setState(() {
      if (_tipoGradiente == 'Aritmético') {
        if (vp > 0) {
          // Calcular valor futuro (VF) dado el valor presente (VP)
          _resultado = 'Valor Futuro (VF): \$${_calcularVFAritmetico(serie, gradiente, tasa, periodos, vp).toStringAsFixed(2)}';
        } else if (vf > 0) {
          // Calcular valor presente (VP) dado el valor futuro (VF)
          _resultado = 'Valor Presente (VP): \$${_calcularVPAritmetico(serie, gradiente, tasa, periodos, vf).toStringAsFixed(2)}';
        } else {
          // Calcular valor de la serie dado VP o VF
          _resultado = 'Valor de la Serie: \$${_calcularSerieAritmetico(serie, gradiente, tasa, periodos).toStringAsFixed(2)}';
        }
      } else {
        if (vp > 0) {
          // Calcular valor futuro (VF) dado el valor presente (VP)
          _resultado = 'Valor Futuro (VF): \$${_calcularVFGeometrico(serie, gradiente, tasa, periodos, vp).toStringAsFixed(2)}';
        } else if (vf > 0) {
          // Calcular valor presente (VP) dado el valor futuro (VF)
          _resultado = 'Valor Presente (VP): \$${_calcularVPGeometrico(serie, gradiente, tasa, periodos, vf).toStringAsFixed(2)}';
        } else {
          // Calcular valor de la serie dado VP o VF
          _resultado = 'Valor de la Serie: \$${_calcularSerieGeometrico(serie, gradiente, tasa, periodos).toStringAsFixed(2)}';
        }
      }
    });
  }

  // Método para calcular el valor futuro en un gradiente aritmético
  double _calcularVFAritmetico(double serie, double gradiente, double tasa, int periodos, double vp) {
    double tasaDecimal = tasa / 100;
    double vf = vp * pow(1 + tasaDecimal, periodos);
    return vf;
  }

  // Método para calcular el valor presente en un gradiente aritmético
  double _calcularVPAritmetico(double serie, double gradiente, double tasa, int periodos, double vf) {
    double tasaDecimal = tasa / 100;
    double vp = vf / pow(1 + tasaDecimal, periodos);
    return vp;
  }

  // Método para calcular el valor de la serie en un gradiente aritmético
  double _calcularSerieAritmetico(double serie, double gradiente, double tasa, int periodos) {
    double tasaDecimal = tasa / 100;
    double serieCalculada = serie + (gradiente * (periodos - 1));
    return serieCalculada;
  }

  // Método para calcular el valor futuro en un gradiente geométrico
  double _calcularVFGeometrico(double serie, double gradiente, double tasa, int periodos, double vp) {
    double tasaDecimal = tasa / 100;
    double vf = vp * pow(1 + tasaDecimal, periodos);
    return vf;
  }

  // Método para calcular el valor presente en un gradiente geométrico
  double _calcularVPGeometrico(double serie, double gradiente, double tasa, int periodos, double vf) {
    double tasaDecimal = tasa / 100;
    double vp = vf / pow(1 + tasaDecimal, periodos);
    return vp;
  }

  // Método para calcular el valor de la serie en un gradiente geométrico
  double _calcularSerieGeometrico(double serie, double gradiente, double tasa, int periodos) {
    double tasaDecimal = tasa / 100;
    double serieCalculada = serie * pow(1 + gradiente, periodos - 1);
    return serieCalculada;
  }

  // Método para construir un campo de texto
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gradientes'),
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
              // Campo para el valor de la serie
              _buildTextField('Valor de la Serie', _serieController),
              const SizedBox(height: 20),
              // Campo para el valor del gradiente
              _buildTextField('Valor del Gradiente', _gradienteController),
              const SizedBox(height: 20),
              // Campo para la tasa de interés
              _buildTextField('Tasa de Interés (%)', _tasaController),
              const SizedBox(height: 20),
              // Campo para el número de periodos
              _buildTextField('Número de Periodos', _periodosController),
              const SizedBox(height: 20),
              // Campo para el valor presente (VP)
              _buildTextField('Valor Presente (VP)', _vpController),
              const SizedBox(height: 20),
              // Campo para el valor futuro (VF)
              _buildTextField('Valor Futuro (VF)', _vfController),
              const SizedBox(height: 20),
              // Selección del tipo de gradiente
              DropdownButton<String>(
                value: _tipoGradiente,
                onChanged: (String? newValue) {
                  setState(() {
                    _tipoGradiente = newValue!;
                  });
                },
                items: <String>['Aritmético', 'Geométrico']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Botón para calcular
              ElevatedButton(
                onPressed: _calcular,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: const Text('Calcular'),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}