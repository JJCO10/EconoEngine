import 'dart:math';
import 'package:flutter/material.dart';

class GradientesView extends StatefulWidget {
  const GradientesView({Key? key}) : super(key: key);

  @override
  _GradientesViewState createState() => _GradientesViewState();
}

class _GradientesViewState extends State<GradientesView> {
  // Variables para gradiente aritmético
  double valorPresenteAritmetico = 0;
  double valorFuturoAritmetico = 0;
  double serieAritmetico = 0;
  double primerPagoAritmetico = 0;
  double gradienteAritmetico = 0;
  double tasaInteresAritmetico = 0;
  int periodosAritmetico = 0;

  // Variables para gradiente geométrico
  double valorPresenteGeometrico = 0;
  double valorFuturoGeometrico = 0;
  double serieGeometrico = 0;
  double primerPagoGeometrico = 0;
  double tasaCrecimientoGeometrico = 0;
  double tasaInteresGeometrico = 0;
  int periodosGeometrico = 0;

  // Controladores para los campos de texto
  final TextEditingController _controllerPrimerPago = TextEditingController();
  final TextEditingController _controllerGradiente = TextEditingController();
  final TextEditingController _controllerTasaInteres = TextEditingController();
  final TextEditingController _controllerPeriodos = TextEditingController();
  final TextEditingController _controllerTasaCrecimiento = TextEditingController();

  // Variable para seleccionar el tipo de gradiente
  String _tipoGradiente = "Aritmético";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gradientes Aritméticos y Geométricos'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selección de tipo de gradiente
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "Seleccione el tipo de gradiente:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: _tipoGradiente,
                      onChanged: (String? newValue) {
                        setState(() {
                          _tipoGradiente = newValue!;
                        });
                      },
                      items: <String>["Aritmético", "Geométrico"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Campos de entrada
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInputField(
                      "Primer Pago (A)",
                      _controllerPrimerPago,
                      hintText: "Ej: 1000",
                      suffixText: "\$",
                    ),
                    const SizedBox(height: 10),
                    if (_tipoGradiente == "Aritmético")
                      _buildInputField(
                        "Gradiente (G)",
                        _controllerGradiente,
                        hintText: "Ej: 100",
                        suffixText: "\$",
                      ),
                    if (_tipoGradiente == "Geométrico")
                      _buildInputField(
                        "Tasa de Crecimiento (g)",
                        _controllerTasaCrecimiento,
                        hintText: "Ej: 0.05 (5%)",
                        suffixText: "%",
                      ),
                    const SizedBox(height: 10),
                    _buildInputField(
                      "Tasa de Interés (i)",
                      _controllerTasaInteres,
                      hintText: "Ej: 0.10 (10%)",
                      suffixText: "%",
                    ),
                    const SizedBox(height: 10),
                    _buildInputField(
                      "Número de Períodos (n)",
                      _controllerPeriodos,
                      hintText: "Ej: 12 (meses)",
                      suffixText: "meses/años",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botón para calcular
            Center(
              child: ElevatedButton(
                onPressed: _calcularGradiente,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                ),
                child: const Text("Calcular"),
              ),
            ),
            const SizedBox(height: 20),

            // Mostrar resultados
            if (_tipoGradiente == "Aritmético")
              _buildTablaResultadosAritmetico(),
            if (_tipoGradiente == "Geométrico")
              _buildTablaResultadosGeometrico(),
          ],
        ),
      ),
    );
  }

  // Método para construir campos de entrada con estilos
  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    String? hintText,
    String? suffixText,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        suffixText: suffixText,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      controller: controller,
    );
  }

  // Método para calcular el gradiente seleccionado
  void _calcularGradiente() {
    double primerPago = double.tryParse(_controllerPrimerPago.text) ?? 0;
    double tasaInteres = double.tryParse(_controllerTasaInteres.text) ?? 0;
    int periodos = int.tryParse(_controllerPeriodos.text) ?? 0;

    if (_tipoGradiente == "Aritmético") {
      double gradiente = double.tryParse(_controllerGradiente.text) ?? 0;
      _calcularGradienteAritmetico(primerPago, gradiente, tasaInteres, periodos);
    } else if (_tipoGradiente == "Geométrico") {
      double tasaCrecimiento = double.tryParse(_controllerTasaCrecimiento.text) ?? 0;
      _calcularGradienteGeometrico(primerPago, tasaCrecimiento, tasaInteres, periodos);
    }

    setState(() {});
  }

  // Método para calcular gradiente aritmético
  void _calcularGradienteAritmetico(double primerPago, double gradiente, double tasaInteres, int periodos) {
    double i = tasaInteres / 100;

    // Valor Presente
    double factor1 = (1 - (1 / pow(1 + i, periodos))) / i;
    double factor2 = (1 - (1 + periodos * i) / pow(1 + i, periodos)) / i;
    valorPresenteAritmetico = primerPago * factor1 + gradiente * factor2;

    // Valor Futuro
    double factor3 = (pow(1 + i, periodos) - 1) / i;
    double factor4 = ((pow(1 + i, periodos) - 1) / (i * i)) - (periodos / i);
    valorFuturoAritmetico = primerPago * factor3 + gradiente * factor4;

    // Serie
    serieAritmetico = primerPago + (gradiente * (periodos - 1));
  }

  // Método para calcular gradiente geométrico
  void _calcularGradienteGeometrico(double primerPago, double tasaCrecimiento, double tasaInteres, int periodos) {
    double i = tasaInteres / 100;
    double g = tasaCrecimiento / 100;

    // Valor Presente
    if (i != g) {
      valorPresenteGeometrico = primerPago * ((1 - pow((1 + g) / (1 + i), periodos))) / (i - g);
    } else {
      valorPresenteGeometrico = primerPago * (periodos / (1 + i));
    }

    // Valor Futuro
    valorFuturoGeometrico = primerPago * ((pow(1 + i, periodos) - pow(1 + g, periodos))) / (i - g);

    // Serie
    serieGeometrico = primerPago * pow(1 + g, periodos - 1);
  }

  // Método para construir la tabla de resultados (aritmético)
  Widget _buildTablaResultadosAritmetico() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Concepto")),
            DataColumn(label: Text("Valor")),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text("Valor Presente")),
              DataCell(Text(valorPresenteAritmetico.toStringAsFixed(2))),
            ]),
            DataRow(cells: [
              const DataCell(Text("Valor Futuro")),
              DataCell(Text(valorFuturoAritmetico.toStringAsFixed(2))),
            ]),
            DataRow(cells: [
              const DataCell(Text("Serie")),
              DataCell(Text(serieAritmetico.toStringAsFixed(2))),
            ]),
          ],
        ),
      ),
    );
  }

  // Método para construir la tabla de resultados (geométrico)
  Widget _buildTablaResultadosGeometrico() {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Concepto")),
            DataColumn(label: Text("Valor")),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text("Valor Presente")),
              DataCell(Text(valorPresenteGeometrico.toStringAsFixed(2))),
            ]),
            DataRow(cells: [
              const DataCell(Text("Valor Futuro")),
              DataCell(Text(valorFuturoGeometrico.toStringAsFixed(2))),
            ]),
            DataRow(cells: [
              const DataCell(Text("Serie")),
              DataCell(Text(serieGeometrico.toStringAsFixed(2))),
            ]),
          ],
        ),
      ),
    );
  }
}