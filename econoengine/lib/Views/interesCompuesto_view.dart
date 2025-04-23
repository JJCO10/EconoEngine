import 'package:econoengine/l10n/app_localizations_setup.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InteresCompuestoController>().initialize(context);
    });
  }

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
    final tresLlenos =
        context.read<InteresCompuestoController>().tresCamposLlenos;
    return tresLlenos && controller.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final controller = context.watch<InteresCompuestoController>();
    const List<String> unidadesTiempoIngles = [
      'days',
      'months',
      'quarters',
      'semesters',
      'years'
    ];
    const List<String> unidadesTasaIngles = [
      'daily',
      'monthly',
      'quarterly',
      'semiannual',
      'annual'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.compoundInterest),
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
                loc.initialCapital,
                _cController,
                hint: "Ej: 1000",
                suffix: "\$",
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                loc.compoundAmount,
                _mcController,
                hint: "Ej: 2000",
                suffix: "\$",
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                loc.interestRate,
                _iController,
                hint: "Ej: 10",
                suffix: "%",
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: controller.unidadTasa,
                items: unidadesTasaIngles.map((unidadIngles) {
                  return DropdownMenuItem(
                    value: unidadIngles,
                    child:
                        Text('${loc.rateUnit} ${loc.translate(unidadIngles)}'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) controller.cambiarUnidadTasa(value);
                },
                decoration: InputDecoration(
                  labelText: loc.rateUnit,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                loc.tiempoInteresCompuesto,
                _nController,
                hint: "Ej: 5",
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: controller.unidadTiempo,
                items: unidadesTiempoIngles.map((unidadIngles) {
                  return DropdownMenuItem(
                    value: unidadIngles,
                    child: Text(loc.translate(unidadIngles)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) controller.cambiarUnidadTiempo(value);
                },
                decoration: InputDecoration(
                  labelText: loc.timeUnit,
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
                      loc.calculateMC,
                      Colors.blue[800]!,
                      () {
                        context
                            .read<InteresCompuestoController>()
                            .calcularMontoCompuesto(
                              context, // Pasar el BuildContext
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
                      loc.calculaten,
                      Colors.green[800]!,
                      () {
                        context
                            .read<InteresCompuestoController>()
                            .calcularTiempo(
                              context, // Pasar el BuildContext
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
                      loc.calculatei,
                      Colors.orange[800]!,
                      () {
                        context
                            .read<InteresCompuestoController>()
                            .calcularTasaInteres(
                              context, // Pasar el BuildContext
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
