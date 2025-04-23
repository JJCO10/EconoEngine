import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controllers/interesSimple_controller.dart';
import 'package:econoengine/l10n/app_localizations_setup.dart';

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
  void initState() {
    super.initState();
    // Inicializa el controlador aquí, después de que el widget se construye
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InteresSimpleController>(context, listen: false)
          .initialize(context);
    });
  }

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
    final loc = AppLocalizations.of(context);

    final List<String> unidadesTiempo = [
      loc.days,
      loc.months,
      loc.quarters,
      loc.semesters,
      loc.years
    ];
    final List<String> unidadesTasa = [
      loc.daily,
      loc.monthly,
      loc.quarterly,
      loc.semiannually,
      loc.annually
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.simpleInterest),
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
                loc.presentValue,
                _vpController,
                hint: "Ej: 1000",
                suffix: "\$",
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                loc.futureValue,
                _vfController,
                hint: "Ej: 1500",
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
              // Selector de unidad de tasa
              DropdownButtonFormField<String>(
                value: controller.unidadTasa,
                items: unidadesTasa.map((unidad) {
                  return DropdownMenuItem(
                    value: unidad,
                    child: Text('${loc.rate} $unidad'),
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
                loc.tiempo,
                _tController,
                hint: "Ej: 5",
              ),
              const SizedBox(height: 10),
              // Selector de unidad de tiempo
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
                      loc.calculateFv,
                      Colors.blue[800]!,
                      () {
                        controller.calcularVF(
                          context,
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
                      loc.calculatePv,
                      Colors.purple[800]!,
                      () {
                        controller.calcularVP(
                          context,
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
                      loc.calculateI,
                      Colors.green[800]!,
                      () {
                        controller.calcularTasa(
                          context,
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
                      loc.calculateT,
                      Colors.orange[800]!,
                      () {
                        controller.calcularTiempo(
                          context,
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
