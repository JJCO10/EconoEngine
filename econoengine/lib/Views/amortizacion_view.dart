import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controllers/amortizacion_controller.dart';

class AmortizacionView extends StatefulWidget {
  const AmortizacionView({super.key});

  @override
  State<AmortizacionView> createState() => _AmortizacionViewState();
}

class _AmortizacionViewState extends State<AmortizacionView> {
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _tasaController = TextEditingController();
  final TextEditingController _periodosController = TextEditingController();

  @override
  void dispose() {
    _montoController.dispose();
    _tasaController.dispose();
    _periodosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AmortizacionController>();

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
              _buildInputField(
                'Monto del Préstamo',
                _montoController,
                hintText: "Ej: 10000",
                suffixText: "\$",
              ),
              const SizedBox(height: 20),
              _buildInputField(
                'Tasa de Interés Anual',
                _tasaController,
                hintText: "Ej: 12 (para 12%)",
                suffixText: "%",
              ),
              const SizedBox(height: 20),
              _buildInputField(
                'Número de Periodos',
                _periodosController,
                hintText: "Ej: 12 (meses)",
                suffixText: "meses",
              ),
              const SizedBox(height: 20),
              _buildDropdownMetodo(controller),
              const SizedBox(height: 20),
              if (controller.hasError)
                Text(
                  controller.error,
                  style: const TextStyle(color: Colors.red),
                ),
              _buildBotonCalcular(controller),
              const SizedBox(height: 30),
              if (controller.tablaAmortizacion.isNotEmpty)
                _buildTablaAmortizacion(controller),
            ],
          ),
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
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDropdownMetodo(AmortizacionController controller) {
    return DropdownButton<String>(
      value: controller.metodoSeleccionado,
      onChanged: (String? newValue) {
        if (newValue != null) {
          controller.cambiarMetodo(newValue);
        }
      },
      items: <String>['Alemán', 'Francés', 'Americano']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildBotonCalcular(AmortizacionController controller) {
    return ElevatedButton(
      onPressed: () {
        final monto = double.tryParse(_montoController.text) ?? 0;
        final tasa = double.tryParse(_tasaController.text) ?? 0;
        final periodos = int.tryParse(_periodosController.text) ?? 0;
        
        controller.calcularAmortizacion(monto, tasa, periodos);
      },
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
    );
  }

  Widget _buildTablaAmortizacion(AmortizacionController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Periodo')),
          DataColumn(label: Text('Cuota')),
          DataColumn(label: Text('Interés')),
          DataColumn(label: Text('Capital')),
          DataColumn(label: Text('Saldo')),
        ],
        rows: controller.tablaAmortizacion.map((fila) {
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
    );
  }
}