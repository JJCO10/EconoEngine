import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controllers/capitalizacion_controller.dart';

class CapitalizacionView extends StatefulWidget {
  const CapitalizacionView({super.key});

  @override
  State<CapitalizacionView> createState() => _CapitalizacionViewState();
}

class _CapitalizacionViewState extends State<CapitalizacionView> {
  final TextEditingController _aporteController = TextEditingController();
  final TextEditingController _tasaInteresController = TextEditingController();
  final TextEditingController _plazoController = TextEditingController();
  final TextEditingController _comisionController = TextEditingController();
  final TextEditingController _participantesController = TextEditingController();
  final TextEditingController _tasaRepartoController = TextEditingController();
  final TextEditingController _porcentajeCapController = TextEditingController();
  final TextEditingController _primaController = TextEditingController();
  final TextEditingController _costoSeguroController = TextEditingController();
  final TextEditingController _aporteExtraController = TextEditingController();

  List<TextEditingController> _aportesColectivos = [];
  int _frecuenciaPago = 12; // Mensual por defecto

  @override
  void dispose() {
    _aporteController.dispose();
    _tasaInteresController.dispose();
    _plazoController.dispose();
    _comisionController.dispose();
    _participantesController.dispose();
    _tasaRepartoController.dispose();
    _porcentajeCapController.dispose();
    _primaController.dispose();
    _costoSeguroController.dispose();
    _aporteExtraController.dispose();
    for (var controller in _aportesColectivos) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CapitalizacionController>(context);
    final sistemas = [
      'Individual',
      'Colectiva',
      'Mixto',
      'Seguros'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistemas de Capitalización'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSistemaSelector(controller, sistemas),
            const SizedBox(height: 20),
            _buildFormBySistema(controller),
            const SizedBox(height: 20),
            if (controller.hasError) _buildError(controller),
            if (controller.resultados != null) _buildResultados(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildSistemaSelector(CapitalizacionController controller, List<String> sistemas) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Seleccione el sistema:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: controller.sistemaSeleccionado,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.cambiarSistema(newValue);
                  _clearInputs();
                }
              },
              items: sistemas.map<DropdownMenuItem<String>>((String value) {
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

  Widget _buildFormBySistema(CapitalizacionController controller) {
    switch (controller.sistemaSeleccionado) {
      case 'Individual':
        return _buildIndividualForm(controller);
      case 'Colectiva':
        return _buildColectivaForm(controller);
      case 'Mixto':
        return _buildMixtoForm(controller);
      case 'Seguros':
        return _buildSegurosForm(controller);
      default:
        return Container();
    }
  }

  Widget _buildIndividualForm(CapitalizacionController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _aporteController,
              decoration: const InputDecoration(
                labelText: 'Aporte mensual',
                hintText: 'Ej: 500000',
                suffixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tasaInteresController,
              decoration: const InputDecoration(
                labelText: 'Tasa de interés anual (%)',
                hintText: 'Ej: 8.5',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _plazoController,
              decoration: const InputDecoration(
                labelText: 'Plazo en años',
                hintText: 'Ej: 10',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _comisionController,
              decoration: const InputDecoration(
                labelText: 'Comisión administrativa (%)',
                hintText: 'Ej: 1.5',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final aporte = double.tryParse(_aporteController.text) ?? 0;
                final tasa = double.tryParse(_tasaInteresController.text) ?? 0;
                final plazo = int.tryParse(_plazoController.text) ?? 0;
                final comision = double.tryParse(_comisionController.text) ?? 0;
                controller.calcularIndividual(
                  aporteMensual: aporte,
                  tasaInteres: tasa,
                  plazoAnos: plazo,
                  comisionAdministrativa: comision,
                );
              },
              child: const Text('Calcular'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColectivaForm(CapitalizacionController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _participantesController,
              decoration: const InputDecoration(
                labelText: 'Número de participantes',
                hintText: 'Ej: 5',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final participantes = int.tryParse(value) ?? 0;
                if (participantes > _aportesColectivos.length) {
                  setState(() {
                    final diferencia = participantes - _aportesColectivos.length;
                    for (int i = 0; i < diferencia; i++) {
                      _aportesColectivos.add(TextEditingController());
                    }
                  });
                } else if (participantes < _aportesColectivos.length && participantes > 0) {
                  setState(() {
                    _aportesColectivos.removeRange(
                      participantes, 
                      _aportesColectivos.length
                    );
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            if (_aportesColectivos.isNotEmpty) ...[
              const Text(
                'Aportes mensuales por participante:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._aportesColectivos.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: entry.value,
                    decoration: InputDecoration(
                      labelText: 'Participante ${entry.key + 1}',
                      hintText: 'Aporte mensual',
                      suffixText: '\$',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                );
              }).toList(),
            ],
            const SizedBox(height: 10),
            TextField(
              controller: _tasaInteresController,
              decoration: const InputDecoration(
                labelText: 'Tasa de interés anual (%)',
                hintText: 'Ej: 8.5',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _plazoController,
              decoration: const InputDecoration(
                labelText: 'Plazo en años',
                hintText: 'Ej: 10',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _comisionController,
              decoration: const InputDecoration(
                labelText: 'Comisión administrativa (%)',
                hintText: 'Ej: 1.5',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final participantes = int.tryParse(_participantesController.text) ?? 0;
                final aportes = _aportesColectivos
                    .map((c) => double.tryParse(c.text) ?? 0)
                    .toList();
                final tasa = double.tryParse(_tasaInteresController.text) ?? 0;
                final plazo = int.tryParse(_plazoController.text) ?? 0;
                final comision = double.tryParse(_comisionController.text) ?? 0;
                
                if (participantes <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ingrese un número válido de participantes')));
                  return;
                }
                
                controller.calcularColectiva(
                  aportes: aportes,
                  tasaInteres: tasa,
                  plazoAnos: plazo,
                  comisionAdministrativa: comision,
                  participantes: participantes,
                );
              },
              child: const Text('Calcular'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMixtoForm(CapitalizacionController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _aporteController,
              decoration: const InputDecoration(
                labelText: 'Aporte mensual total',
                hintText: 'Ej: 500000',
                suffixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tasaInteresController,
              decoration: const InputDecoration(
                labelText: 'Tasa de interés capitalización (%)',
                hintText: 'Ej: 8.5',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tasaRepartoController,
              decoration: const InputDecoration(
                labelText: 'Tasa de interés reparto (%)',
                hintText: 'Ej: 5.0',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _plazoController,
              decoration: const InputDecoration(
                labelText: 'Plazo en años',
                hintText: 'Ej: 10',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _porcentajeCapController,
              decoration: const InputDecoration(
                labelText: 'Porcentaje capitalización (%)',
                hintText: 'Ej: 70 (para 70%)',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final aporte = double.tryParse(_aporteController.text) ?? 0;
                final tasaCap = double.tryParse(_tasaInteresController.text) ?? 0;
                final tasaRep = double.tryParse(_tasaRepartoController.text) ?? 0;
                final plazo = int.tryParse(_plazoController.text) ?? 0;
                final porcentaje = double.tryParse(_porcentajeCapController.text) ?? 0;
                
                controller.calcularMixto(
                  aporteMensual: aporte,
                  tasaInteresCapitalizacion: tasaCap,
                  tasaInteresReparto: tasaRep,
                  plazoAnos: plazo,
                  porcentajeCapitalizacion: porcentaje,
                );
              },
              child: const Text('Calcular'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegurosForm(CapitalizacionController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _primaController,
              decoration: const InputDecoration(
                labelText: 'Prima',
                hintText: 'Ej: 200000',
                suffixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tasaInteresController,
              decoration: const InputDecoration(
                labelText: 'Tasa de interés anual (%)',
                hintText: 'Ej: 6.0',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _plazoController,
              decoration: const InputDecoration(
                labelText: 'Plazo en años',
                hintText: 'Ej: 10',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _comisionController,
              decoration: const InputDecoration(
                labelText: 'Comisión administrativa (%)',
                hintText: 'Ej: 2.0',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _costoSeguroController,
              decoration: const InputDecoration(
                labelText: 'Costo del seguro',
                hintText: 'Ej: 5000',
                suffixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: _frecuenciaPago,
              decoration: const InputDecoration(
                labelText: 'Frecuencia de pago',
              ),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Anual')),
                DropdownMenuItem(value: 2, child: Text('Semestral')),
                DropdownMenuItem(value: 4, child: Text('Trimestral')),
                DropdownMenuItem(value: 12, child: Text('Mensual')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _frecuenciaPago = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final prima = double.tryParse(_primaController.text) ?? 0;
                final tasa = double.tryParse(_tasaInteresController.text) ?? 0;
                final plazo = int.tryParse(_plazoController.text) ?? 0;
                final comision = double.tryParse(_comisionController.text) ?? 0;
                final seguro = double.tryParse(_costoSeguroController.text) ?? 0;
                
                controller.calcularSeguros(
                  prima: prima,
                  tasaInteres: tasa,
                  plazoAnos: plazo,
                  comisionAdministrativa: comision,
                  costoSeguro: seguro,
                  frecuenciaPago: _frecuenciaPago,
                );
              },
              child: const Text('Calcular'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(CapitalizacionController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        controller.error,
        style: const TextStyle(color: Colors.red, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildResultados(CapitalizacionController controller) {
    if (controller.resultados is Map) {
      final resultados = controller.resultados as Map<String, dynamic>;
      
      if (controller.sistemaSeleccionado == 'Colectiva' && 
          resultados.containsKey('saldosIndividuales')) {
        return _buildResultadosColectivos(resultados);
      }
      
      return Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resultados - Sistema ${controller.sistemaSeleccionado}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              ...resultados.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _traducirConcepto(entry.key),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        entry.value is double 
                            ? entry.value >= 1000
                                ? '\$${entry.value.toStringAsFixed(0)}'
                                : '\$${entry.value.toStringAsFixed(2)}'
                            : entry.value is List
                                ? 'Ver detalles'
                                : entry.value.toString(),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
    }
    return Container();
  }

  Widget _buildResultadosColectivos(Map<String, dynamic> resultados) {
    final saldosIndividuales = resultados['saldosIndividuales'] as List<double>;
    
    return Card(
      elevation: 5,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resultados - Sistema Colectivo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Saldo total del grupo:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('\$${resultados['saldoTotal'].toStringAsFixed(0)}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total aportes:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('\$${resultados['totalAportes'].toStringAsFixed(0)}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total intereses:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('\$${resultados['totalIntereses'].toStringAsFixed(0)}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total comisiones:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('\$${resultados['totalComisiones'].toStringAsFixed(0)}'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Saldos individuales:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            ...saldosIndividuales.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Participante ${entry.key + 1}:'),
                    Text('\$${entry.value.toStringAsFixed(0)}'),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _traducirConcepto(String key) {
    return {
      'saldoFinal': 'Saldo final',
      'totalAportes': 'Total aportes',
      'totalIntereses': 'Total intereses',
      'totalComisiones': 'Total comisiones',
      'saldoTotal': 'Saldo total',
      'saldoCapitalizacion': 'Saldo capitalización',
      'saldoReparto': 'Saldo reparto',
      'totalInteresesCap': 'Intereses capitalización',
      'totalInteresesRep': 'Intereses reparto',
      'totalPrimas': 'Total primas',
      'totalSeguro': 'Total seguro',
    }[key] ?? key;
  }

  void _clearInputs() {
    setState(() {
      _aporteController.clear();
      _tasaInteresController.clear();
      _plazoController.clear();
      _comisionController.clear();
      _participantesController.clear();
      _tasaRepartoController.clear();
      _porcentajeCapController.clear();
      _primaController.clear();
      _costoSeguroController.clear();
      _aportesColectivos.clear();
      _frecuenciaPago = 12;
    });
  }
}