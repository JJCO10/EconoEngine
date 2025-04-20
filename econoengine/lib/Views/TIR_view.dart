import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controllers/tir_controller.dart';

class TirView extends StatefulWidget {
  const TirView({super.key});

  @override
  State<TirView> createState() => _TirViewState();
}

class _TirViewState extends State<TirView> {
  final TextEditingController _flujoController = TextEditingController();
  final TextEditingController _tasaReinversionController = TextEditingController();
  final TextEditingController _tasaFinanciamientoController = TextEditingController();
  final TextEditingController _beneficioNetoController = TextEditingController();
  final TextEditingController _inversionInicialController = TextEditingController();
  final TextEditingController _tasaLibreRiesgoController = TextEditingController();
  final TextEditingController _primaRiesgoController = TextEditingController();
  final TextEditingController _betaController = TextEditingController();
  final TextEditingController _retornoNominalController = TextEditingController();
  final TextEditingController _inflacionController = TextEditingController();
  final TextEditingController _retornoController = TextEditingController();
  final TextEditingController _probabilidadController = TextEditingController();

  List<double> _flujos = [];
  List<double> _posiblesRetornos = [];
  List<double> _probabilidades = [];

  @override
  void dispose() {
    _flujoController.dispose();
    _tasaReinversionController.dispose();
    _tasaFinanciamientoController.dispose();
    _beneficioNetoController.dispose();
    _inversionInicialController.dispose();
    _tasaLibreRiesgoController.dispose();
    _primaRiesgoController.dispose();
    _betaController.dispose();
    _retornoNominalController.dispose();
    _inflacionController.dispose();
    _retornoController.dispose();
    _probabilidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<TirController>(context);
    final modos = ['TIR', 'TIRM', 'TRA', 'TRR', 'Retorno Real', 'Retorno Esperado'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasas de Retorno'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildModoSelector(controller, modos),
            const SizedBox(height: 20),
            _buildFormByModo(controller),
            const SizedBox(height: 20),
            if (controller.hasError) _buildError(controller),
            if (controller.resultado != 0) _buildResultado(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildModoSelector(TirController controller, List<String> modos) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Seleccione el modo de cálculo:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: controller.modoSeleccionado,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.cambiarModo(newValue);
                  _clearInputs();
                }
              },
              items: modos.map<DropdownMenuItem<String>>((String value) {
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

  Widget _buildFormByModo(TirController controller) {
    switch (controller.modoSeleccionado) {
      case 'TIR':
        return _buildTIRForm(controller);
      case 'TIRM':
        return _buildTIRMForm(controller);
      case 'TRA':
        return _buildTRAForm(controller);
      case 'TRR':
        return _buildTRRForm(controller);
      case 'Retorno Real':
        return _buildRetornoRealForm(controller);
      case 'Retorno Esperado':
        return _buildRetornoEsperadoForm(controller);
      default:
        return Container();
    }
  }

  Widget _buildTIRForm(TirController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Ingrese los flujos de caja:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _flujoController,
                    decoration: const InputDecoration(
                      labelText: 'Flujo de caja',
                      hintText: 'Ej: -1000 (inversión inicial)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final value = double.tryParse(_flujoController.text);
                    if (value != null) {
                      setState(() {
                        _flujos.add(value);
                        _flujoController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_flujos.isNotEmpty) _buildFlujosList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_flujos.isNotEmpty) {
                  controller.calcularTIR(_flujos);
                }
              },
              child: const Text('Calcular TIR'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlujosList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Flujos ingresados:'),
        const SizedBox(height: 5),
        Wrap(
          spacing: 8,
          children: _flujos.map((flujo) {
            return Chip(
              label: Text(flujo.toStringAsFixed(2)),
              onDeleted: () {
                setState(() {
                  _flujos.remove(flujo);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTIRMForm(TirController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Ingrese los flujos de caja:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _flujoController,
                    decoration: const InputDecoration(
                      labelText: 'Flujo de caja',
                      hintText: 'Ej: -1000 (inversión inicial)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final value = double.tryParse(_flujoController.text);
                    if (value != null) {
                      setState(() {
                        _flujos.add(value);
                        _flujoController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_flujos.isNotEmpty) _buildFlujosList(),
            const SizedBox(height: 20),
            TextField(
              controller: _tasaReinversionController,
              decoration: const InputDecoration(
                labelText: 'Tasa de reinversión (%)',
                hintText: 'Ej: 10 (para 10%)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tasaFinanciamientoController,
              decoration: const InputDecoration(
                labelText: 'Tasa de financiamiento (%)',
                hintText: 'Ej: 8 (para 8%)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_flujos.isNotEmpty) {
                  final tasaReinversion = double.tryParse(_tasaReinversionController.text) ?? 0;
                  final tasaFinanciamiento = double.tryParse(_tasaFinanciamientoController.text) ?? 0;
                  controller.calcularTIRM(
                    _flujos,
                    tasaReinversion / 100,
                    tasaFinanciamiento / 100,
                  );
                }
              },
              child: const Text('Calcular TIRM'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTRAForm(TirController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _beneficioNetoController,
              decoration: const InputDecoration(
                labelText: 'Beneficio neto promedio',
                hintText: 'Ej: 5000',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _inversionInicialController,
              decoration: const InputDecoration(
                labelText: 'Inversión inicial',
                hintText: 'Ej: 25000',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final beneficioNeto = double.tryParse(_beneficioNetoController.text) ?? 0;
                final inversionInicial = double.tryParse(_inversionInicialController.text) ?? 0;
                controller.calcularTRA(beneficioNeto, inversionInicial);
              },
              child: const Text('Calcular TRA'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTRRForm(TirController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tasaLibreRiesgoController,
              decoration: const InputDecoration(
                labelText: 'Tasa libre de riesgo (%)',
                hintText: 'Ej: 3 (para 3%)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _primaRiesgoController,
              decoration: const InputDecoration(
                labelText: 'Prima de riesgo (%)',
                hintText: 'Ej: 5 (para 5%)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _betaController,
              decoration: const InputDecoration(
                labelText: 'Beta',
                hintText: 'Ej: 1.2',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final tasaLibreRiesgo = double.tryParse(_tasaLibreRiesgoController.text) ?? 0;
                final primaRiesgo = double.tryParse(_primaRiesgoController.text) ?? 0;
                final beta = double.tryParse(_betaController.text) ?? 0;
                controller.calcularTRR(tasaLibreRiesgo / 100, primaRiesgo / 100, beta);
              },
              child: const Text('Calcular TRR'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRetornoRealForm(TirController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _retornoNominalController,
              decoration: const InputDecoration(
                labelText: 'Retorno nominal (%)',
                hintText: 'Ej: 12 (para 12%)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _inflacionController,
              decoration: const InputDecoration(
                labelText: 'Inflación (%)',
                hintText: 'Ej: 5 (para 5%)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final retornoNominal = double.tryParse(_retornoNominalController.text) ?? 0;
                final inflacion = double.tryParse(_inflacionController.text) ?? 0;
                controller.calcularRetornoReal(retornoNominal / 100, inflacion / 100);
              },
              child: const Text('Calcular Retorno Real'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRetornoEsperadoForm(TirController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Ingrese posibles retornos y sus probabilidades:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _retornoController,
                    decoration: const InputDecoration(
                      labelText: 'Retorno posible (%)',
                      hintText: 'Ej: 15 (para 15%)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _probabilidadController,
                    decoration: const InputDecoration(
                      labelText: 'Probabilidad (0-1)',
                      hintText: 'Ej: 0.3 (para 30%)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final retorno = double.tryParse(_retornoController.text);
                    final probabilidad = double.tryParse(_probabilidadController.text);
                    if (retorno != null && probabilidad != null) {
                      setState(() {
                        _posiblesRetornos.add(retorno / 100);
                        _probabilidades.add(probabilidad);
                        _retornoController.clear();
                        _probabilidadController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_posiblesRetornos.isNotEmpty) _buildRetornosList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_posiblesRetornos.isNotEmpty) {
                  controller.calcularRetornoEsperado(_posiblesRetornos, _probabilidades);
                }
              },
              child: const Text('Calcular Retorno Esperado'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRetornosList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Retornos y probabilidades ingresados:'),
        const SizedBox(height: 5),
        Wrap(
          spacing: 8,
          children: List.generate(_posiblesRetornos.length, (index) {
            return Chip(
              label: Text(
                '${(_posiblesRetornos[index] * 100).toStringAsFixed(2)}% (${_probabilidades[index].toStringAsFixed(2)})',
              ),
              onDeleted: () {
                setState(() {
                  _posiblesRetornos.removeAt(index);
                  _probabilidades.removeAt(index);
                });
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildError(TirController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        controller.error,
        style: const TextStyle(color: Colors.red, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildResultado(TirController controller) {
    return Card(
      elevation: 5,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${controller.modoSeleccionado}:',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${controller.resultado.toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearInputs() {
    setState(() {
      _flujos.clear();
      _posiblesRetornos.clear();
      _probabilidades.clear();
      _flujoController.clear();
      _tasaReinversionController.clear();
      _tasaFinanciamientoController.clear();
      _beneficioNetoController.clear();
      _inversionInicialController.clear();
      _tasaLibreRiesgoController.clear();
      _primaRiesgoController.clear();
      _betaController.clear();
      _retornoNominalController.clear();
      _inflacionController.clear();
      _retornoController.clear();
      _probabilidadController.clear();
    });
  }
}