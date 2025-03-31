import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controllers/gradientes_controller.dart';

class GradientesView extends StatefulWidget {
  const GradientesView({super.key});

  @override
  State<GradientesView> createState() => _GradientesViewState();
}

class _GradientesViewState extends State<GradientesView> {
  final TextEditingController _primerPagoController = TextEditingController();
  final TextEditingController _gradienteController = TextEditingController();
  final TextEditingController _tasaInteresController = TextEditingController();
  final TextEditingController _periodosController = TextEditingController();
  final TextEditingController _tasaCrecimientoController = TextEditingController();

  @override
  void dispose() {
    _primerPagoController.dispose();
    _gradienteController.dispose();
    _tasaInteresController.dispose();
    _periodosController.dispose();
    _tasaCrecimientoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GradienteController>(context);

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
            _buildSelectorTipo(controller),
            const SizedBox(height: 20),
            _buildCamposEntrada(controller),
            const SizedBox(height: 20),
            if (controller.hasError) _buildError(controller),
            _buildBotonCalcular(controller),
            const SizedBox(height: 20),
            if (controller.resultados.isNotEmpty) _buildResultados(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorTipo(GradienteController controller) {
    return Card(
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
              value: controller.tipoGradiente,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.cambiarTipoGradiente(newValue);
                }
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
    );
  }

  Widget _buildCamposEntrada(GradienteController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputField(
              "Primer Pago (A)",
              _primerPagoController,
              hintText: "Ej: 1000",
              suffixText: "\$",
            ),
            const SizedBox(height: 10),
            if (controller.tipoGradiente == "Aritmético")
              _buildInputField(
                "Gradiente (G)",
                _gradienteController,
                hintText: "Ej: 100",
                suffixText: "\$",
              ),
            if (controller.tipoGradiente == "Geométrico")
              _buildInputField(
                "Tasa de Crecimiento (g)",
                _tasaCrecimientoController,
                hintText: "Ej: 0.05 (5%)",
                suffixText: "%",
              ),
            const SizedBox(height: 10),
            _buildInputField(
              "Tasa de Interés (i)",
              _tasaInteresController,
              hintText: "Ej: 0.10 (10%)",
              suffixText: "%",
            ),
            const SizedBox(height: 10),
            _buildInputField(
              "Número de Períodos (n)",
              _periodosController,
              hintText: "Ej: 12 (meses)",
              suffixText: "meses/años",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(GradienteController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        controller.error,
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }

  Widget _buildBotonCalcular(GradienteController controller) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _calcular(controller),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          backgroundColor: Colors.blue[800],
          foregroundColor: Colors.white,
        ),
        child: const Text("Calcular"),
      ),
    );
  }

  Widget _buildResultados(GradienteController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Concepto")),
            DataColumn(label: Text("Valor")),
          ],
          rows: controller.resultados.entries.map((entry) {
            return DataRow(cells: [
              DataCell(Text(_traducirConcepto(entry.key))),
              DataCell(Text(entry.value.toStringAsFixed(2))),
            ]);
          }).toList(),
        ),
      ),
    );
  }

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

  void _calcular(GradienteController controller) {
    final primerPago = double.tryParse(_primerPagoController.text) ?? 0;
    final tasaInteres = double.tryParse(_tasaInteresController.text) ?? 0;
    final periodos = int.tryParse(_periodosController.text) ?? 0;

    if (controller.tipoGradiente == "Aritmético") {
      final gradiente = double.tryParse(_gradienteController.text) ?? 0;
      controller.calcular(
        primerPago: primerPago,
        gradienteOrTasaCrecimiento: gradiente,
        tasaInteres: tasaInteres,
        periodos: periodos,
      );
    } else {
      final tasaCrecimiento = double.tryParse(_tasaCrecimientoController.text) ?? 0;
      controller.calcular(
        primerPago: primerPago,
        gradienteOrTasaCrecimiento: tasaCrecimiento,
        tasaInteres: tasaInteres,
        periodos: periodos,
      );
    }
  }

  String _traducirConcepto(String key) {
    return {
      'valorPresente': 'Valor Presente',
      'valorFuturo': 'Valor Futuro',
      'serie': 'Serie',
    }[key] ?? key;
  }
}