import 'dart:math';

import 'package:flutter/material.dart';

class AmortizacionView extends StatefulWidget {
  const AmortizacionView({super.key});

  @override
  State<AmortizacionView> createState() => _AmortizacionViewState();
}

class _AmortizacionViewState extends State<AmortizacionView> {
  // Controladores para los campos de texto
  final TextEditingController _montoController = TextEditingController(); // Monto del préstamo
  final TextEditingController _tasaController = TextEditingController(); // Tasa de interés anual
  final TextEditingController _periodosController = TextEditingController(); // Número de periodos

  // Variables para almacenar los resultados
  String _metodoSeleccionado = 'Alemán'; // Método de amortización seleccionado
  List<Map<String, dynamic>> _tablaAmortizacion = []; // Tabla de amortización

  // Método para calcular la tabla de amortización
  void _calcularAmortizacion() {
    double monto = double.tryParse(_montoController.text) ?? 0;
    double tasa = double.tryParse(_tasaController.text) ?? 0;
    int periodos = int.tryParse(_periodosController.text) ?? 0;

    if (monto <= 0 || tasa <= 0 || periodos <= 0) {
      setState(() {
        _tablaAmortizacion = [];
      });
      return;
    }

    setState(() {
      switch (_metodoSeleccionado) {
        case 'Alemán':
          _tablaAmortizacion = _calcularAleman(monto, tasa, periodos);
          break;
        case 'Francés':
          _tablaAmortizacion = _calcularFrances(monto, tasa, periodos);
          break;
        case 'Americano':
          _tablaAmortizacion = _calcularAmericano(monto, tasa, periodos);
          break;
      }
    });
  }

  // Método para calcular la amortización alemana
  List<Map<String, dynamic>> _calcularAleman(double monto, double tasa, int periodos) {
    List<Map<String, dynamic>> tabla = [];
    double capitalConstante = monto / periodos;
    double saldo = monto;

    for (int i = 1; i <= periodos; i++) {
      double interes = saldo * (tasa / 100);
      double cuota = capitalConstante + interes;
      saldo -= capitalConstante;

      tabla.add({
        'Periodo': i,
        'Cuota': cuota.toStringAsFixed(2),
        'Interés': interes.toStringAsFixed(2),
        'Capital': capitalConstante.toStringAsFixed(2),
        'Saldo': saldo.toStringAsFixed(2),
      });
    }

    return tabla;
  }

  // Método para calcular la amortización francesa
  List<Map<String, dynamic>> _calcularFrances(double monto, double tasa, int periodos) {
    List<Map<String, dynamic>> tabla = [];
    double tasaMensual = tasa / 100 / 12;
    double cuota = monto * (tasaMensual * pow(1 + tasaMensual, periodos)) / (pow(1 + tasaMensual, periodos) - 1);
    double saldo = monto;

    for (int i = 1; i <= periodos; i++) {
      double interes = saldo * tasaMensual;
      double capital = cuota - interes;
      saldo -= capital;

      tabla.add({
        'Periodo': i,
        'Cuota': cuota.toStringAsFixed(2),
        'Interés': interes.toStringAsFixed(2),
        'Capital': capital.toStringAsFixed(2),
        'Saldo': saldo.toStringAsFixed(2),
      });
    }

    return tabla;
  }

  // Método para calcular la amortización americana
  List<Map<String, dynamic>> _calcularAmericano(double monto, double tasa, int periodos) {
    List<Map<String, dynamic>> tabla = [];
    double interesPeriodico = monto * (tasa / 100 / 12);

    for (int i = 1; i <= periodos; i++) {
      double cuota = (i == periodos) ? monto + interesPeriodico : interesPeriodico;
      double capital = (i == periodos) ? monto : 0;
      double saldo = (i == periodos) ? 0 : monto;

      tabla.add({
        'Periodo': i,
        'Cuota': cuota.toStringAsFixed(2),
        'Interés': interesPeriodico.toStringAsFixed(2),
        'Capital': capital.toStringAsFixed(2),
        'Saldo': saldo.toStringAsFixed(2),
      });
    }

    return tabla;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amortización'),
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
              // Campo para el monto del préstamo
              _buildTextField('Monto del Préstamo', _montoController),
              const SizedBox(height: 20),
              // Campo para la tasa de interés anual
              _buildTextField('Tasa de Interés Anual (%)', _tasaController),
              const SizedBox(height: 20),
              // Campo para el número de periodos
              _buildTextField('Número de Periodos', _periodosController),
              const SizedBox(height: 20),
              // Selección del método de amortización
              DropdownButton<String>(
                value: _metodoSeleccionado,
                onChanged: (String? newValue) {
                  setState(() {
                    _metodoSeleccionado = newValue!;
                  });
                },
                items: <String>['Alemán', 'Francés', 'Americano']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              // Botón para calcular la amortización
              ElevatedButton(
                onPressed: _calcularAmortizacion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: const Text('Calcular Amortización'),
              ),
              const SizedBox(height: 30),
              // Mostrar la tabla de amortización
              if (_tablaAmortizacion.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Periodo')),
                      DataColumn(label: Text('Cuota')),
                      DataColumn(label: Text('Interés')),
                      DataColumn(label: Text('Capital')),
                      DataColumn(label: Text('Saldo')),
                    ],
                    rows: _tablaAmortizacion.map((fila) {
                      return DataRow(
                        cells: [
                          DataCell(Text(fila['Periodo'].toString())),
                          DataCell(Text(fila['Cuota'])),
                          DataCell(Text(fila['Interés'])),
                          DataCell(Text(fila['Capital'])),
                          DataCell(Text(fila['Saldo'])),
                        ],
                      );
                    }).toList(),
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
      ),
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }
}