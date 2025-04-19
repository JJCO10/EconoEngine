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
    final unidadesTasa = ['anual', 'mensual', 'trimestral', 'semestral', 'diaria'];
    final unidadesPeriodo = ['meses', 'trimestres', 'semestres', 'años', 'días'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Amortización'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(
                'Monto del Préstamo',
                _montoController,
                hint: "Ej: 10000",
                suffix: "\$",
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTextField(
                      'Tasa de Interés',
                      _tasaController,
                      hint: "Ej: 12",
                      suffix: "%",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: _buildDropdown(
                      'Unidad Tasa',
                      unidadesTasa,
                      controller.unidadTasa,
                      (value) => controller.cambiarUnidadTasa(value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTextField(
                      'Número de Periodos',
                      _periodosController,
                      hint: "Ej: 12",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: _buildDropdown(
                      'Unidad Periodo',
                      unidadesPeriodo,
                      controller.unidadPeriodo,
                      (value) => controller.cambiarUnidadPeriodo(value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDropdown(
                'Método de Amortización',
                ['Alemán', 'Francés', 'Americano'],
                controller.metodoSeleccionado,
                (value) => controller.cambiarMetodo(value!),
              ),
              const SizedBox(height: 30),
              
              if (controller.hasError)
                Text(
                  controller.error,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              
              ElevatedButton(
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
                ),
                child: const Text('Calcular Amortización'),
              ),
              const SizedBox(height: 30),
              if (controller.tablaAmortizacion.isNotEmpty)
                _buildTablaAmortizacion(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
    String? suffix,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
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