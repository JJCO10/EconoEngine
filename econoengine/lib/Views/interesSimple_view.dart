import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controllers/interesSimple_controller.dart';

class InteresSimpleView extends StatefulWidget {
  const InteresSimpleView({super.key});

  @override
  State<InteresSimpleView> createState() => _InteresSimpleViewState();
}

class _InteresSimpleViewState extends State<InteresSimpleView> {
  final TextEditingController _vpController = TextEditingController();
  final TextEditingController _vfController = TextEditingController();
  final TextEditingController _iController = TextEditingController();
  final TextEditingController _tController = TextEditingController();

  @override
  void dispose() {
    _vpController.dispose();
    _vfController.dispose();
    _iController.dispose();
    _tController.dispose();
    super.dispose();
  }

  void _actualizarCamposLlenos() {
    final llenos = [_vpController, _vfController, _iController, _tController]
        .where((c) => c.text.isNotEmpty)
        .length;
    context.read<InteresSimpleController>().actualizarCamposLlenos(llenos);
  }

  bool _debeDeshabilitar(TextEditingController controller) {
    final tresLlenos = context.read<InteresSimpleController>().tresCamposLlenos;
    return tresLlenos && controller.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<InteresSimpleController>();

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
            children: [
              _buildTextField(
                context,
                'Valor Presente (VP)',
                _vpController,
                hint: "Ej: 1000",
                suffix: "\$",
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                'Valor Futuro (VF)',
                _vfController,
                hint: "Ej: 1500",
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
              const SizedBox(height: 20),
              _buildTextField(
                context,
                'Tiempo (t)',
                _tController,
                hint: "Ej: 5",
                suffix: "años",
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
                      'Calcular VF',
                      Colors.blue[800]!,
                      () {
                        controller.calcularVF(
                          double.tryParse(_vpController.text),
                          double.tryParse(_iController.text),
                          double.tryParse(_tController.text),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildButton(
                      'Calcular VP',
                      Colors.purple[800]!,
                      () {
                        controller.calcularVP(
                          double.tryParse(_vfController.text),
                          double.tryParse(_iController.text),
                          double.tryParse(_tController.text),
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
                      Colors.green[800]!,
                      () {
                        controller.calcularTasa(
                          double.tryParse(_vpController.text),
                          double.tryParse(_vfController.text),
                          double.tryParse(_tController.text),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildButton(
                      'Calcular t',
                      Colors.orange[800]!,
                      () {
                        controller.calcularTiempo(
                          double.tryParse(_vpController.text),
                          double.tryParse(_vfController.text),
                          double.tryParse(_iController.text),
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