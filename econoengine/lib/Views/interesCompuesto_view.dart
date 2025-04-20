import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controllers/interesCompuesto_controller.dart';

class InteresCompuestoView extends StatefulWidget {
  const InteresCompuestoView({super.key});

  @override
  State<InteresCompuestoView> createState() => _InteresCompuestoViewState();
}

class _InteresCompuestoViewState extends State<InteresCompuestoView> {
  final TextEditingController _cController = TextEditingController();
  final TextEditingController _mcController = TextEditingController();
  final TextEditingController _iController = TextEditingController();
  final TextEditingController _nController = TextEditingController();

  @override
  void dispose() {
    _cController.dispose();
    _mcController.dispose();
    _iController.dispose();
    _nController.dispose();
    super.dispose();
  }

  void _actualizarCamposLlenos() {
    final llenos = [_cController, _mcController, _iController, _nController]
        .where((c) => c.text.isNotEmpty)
        .length;
    context.read<InteresCompuestoController>().actualizarCamposLlenos(llenos);
  }

  bool _debeDeshabilitar(TextEditingController controller) {
    final tresLlenos = context.read<InteresCompuestoController>().tresCamposLlenos;
    return tresLlenos && controller.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<InteresCompuestoController>();
    final List<String> unidadesTiempo = ['días', 'meses', 'trimestres', 'semestres', 'años'];
    final List<String> unidadesTasa = ['diaria', 'mensual', 'trimestral', 'semestral', 'anual'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interés Compuesto'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(
                context,
                'Capital Inicial (C)',
                _cController,
                hint: "Ej: 1000",
                suffix: "\$",
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                'Monto Compuesto (MC)',
                _mcController,
                hint: "Ej: 2000",
                suffix: "\$",
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                'Tasa de Interés (i)',
                _iController,
                hint: "Ej: 10",
                suffix: "%",
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: controller.unidadTasa,
                items: unidadesTasa.map((unidad) {
                  return DropdownMenuItem(
                    value: unidad,
                    child: Text('Tasa $unidad'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) controller.cambiarUnidadTasa(value);
                },
                decoration: const InputDecoration(
                  labelText: 'Unidad de Tasa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                'Tiempo (n)',
                _nController,
                hint: "Ej: 5",
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: controller.unidadTiempo,
                items: unidadesTiempo.map((unidad) {
                  return DropdownMenuItem(
                    value: unidad,
                    child: Text(unidad),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) controller.cambiarUnidadTiempo(value);
                },
                decoration: const InputDecoration(
                  labelText: 'Unidad de Tiempo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              
              if (controller.shouldShowError)
                Text(
                  controller.error,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      'Calcular MC',
                      Colors.blue[800]!,
                      () {
                        controller.calcularMontoCompuesto(
                          double.tryParse(_cController.text),
                          double.tryParse(_iController.text),
                          double.tryParse(_nController.text),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildButton(
                      'Calcular n',
                      Colors.green[800]!,
                      () {
                        controller.calcularTiempo(
                          double.tryParse(_cController.text),
                          double.tryParse(_mcController.text),
                          double.tryParse(_iController.text),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      'Calcular i',
                      Colors.orange[800]!,
                      () {
                        controller.calcularTasaInteres(
                          double.tryParse(_cController.text),
                          double.tryParse(_mcController.text),
                          double.tryParse(_nController.text),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  controller.resultado,
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    String? hint,
    String? suffix,
  }) {
    return TextField(
      controller: controller,
      enabled: !_debeDeshabilitar(controller),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: (_) => _actualizarCamposLlenos(),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: Text(text),
    );
  }
}