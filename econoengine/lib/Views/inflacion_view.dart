import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controllers/inflacion_controller.dart';

class InflacionView extends StatefulWidget {
  const InflacionView({super.key});

  @override
  State<InflacionView> createState() => _InflacionViewState();
}

class _InflacionViewState extends State<InflacionView> {
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _tasaInflacionController =
      TextEditingController();
  final TextEditingController _anosController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _tasaInversionController =
      TextEditingController();
  final TextEditingController _aporteAnualController = TextEditingController();
  final TextEditingController _tasaAnualController = TextEditingController();

  List<TextEditingController> _tasasAnualesControllers = [];

  @override
  void dispose() {
    _montoController.dispose();
    _tasaInflacionController.dispose();
    _anosController.dispose();
    _precioController.dispose();
    _tasaInversionController.dispose();
    _aporteAnualController.dispose();
    _tasaAnualController.dispose();
    for (var controller in _tasasAnualesControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<InflacionController>(context);
    final modos = [
      'Pérdida de valor',
      'Ajuste histórico',
      'Aumento de precio',
      'Inflación acumulada',
      'Comparar inversiones',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Inflación'),
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
            if (controller.resultados != null) _buildResultados(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildModoSelector(
      InflacionController controller, List<String> modos) {
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

  Widget _buildFormByModo(InflacionController controller) {
    switch (controller.modoSeleccionado) {
      case 'Pérdida de valor':
        return _buildPerdidaValorForm(controller);
      case 'Ajuste histórico':
        return _buildAjusteHistoricoForm(controller);
      case 'Aumento de precio':
        return _buildAumentoPrecioForm(controller);
      case 'Inflación acumulada':
        return _buildInflacionAcumuladaForm(controller);
      case 'Comparar inversiones':
        return _buildCompararInversionesForm(controller);
      default:
        return Container();
    }
  }

  Widget _buildPerdidaValorForm(InflacionController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _montoController,
              decoration: const InputDecoration(
                labelText: 'Monto inicial',
                hintText: 'Ej: 1000000',
                suffixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tasaInflacionController,
              decoration: const InputDecoration(
                labelText: 'Tasa de inflación anual (%)',
                hintText: 'Ej: 8.5',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _anosController,
              decoration: const InputDecoration(
                labelText: 'Número de años',
                hintText: 'Ej: 10',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final monto = double.tryParse(_montoController.text) ?? 0;
                final tasa =
                    double.tryParse(_tasaInflacionController.text) ?? 0;
                final anos = int.tryParse(_anosController.text) ?? 0;
                controller.calcularPerdidaValor(
                  montoInicial: monto,
                  tasaInflacionAnual: tasa,
                  anos: anos,
                );
              },
              child: const Text('Calcular Pérdida'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAjusteHistoricoForm(InflacionController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _precioController,
              decoration: const InputDecoration(
                labelText: 'Precio original',
                hintText: 'Ej: 50000',
                suffixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tasaInflacionController,
              decoration: const InputDecoration(
                labelText: 'Tasa de inflación anual (%)',
                hintText: 'Ej: 8.5',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _anosController,
              decoration: const InputDecoration(
                labelText: 'Número de años',
                hintText: 'Ej: 10',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final precio = double.tryParse(_precioController.text) ?? 0;
                final tasa =
                    double.tryParse(_tasaInflacionController.text) ?? 0;
                final anos = int.tryParse(_anosController.text) ?? 0;
                controller.ajustarPrecioHistorico(
                  precioOriginal: precio,
                  tasaInflacionAnual: tasa,
                  anos: anos,
                );
              },
              child: const Text('Ajustar Precio'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAumentoPrecioForm(InflacionController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _precioController,
              decoration: const InputDecoration(
                labelText: 'Precio actual',
                hintText: 'Ej: 100000',
                suffixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tasaInflacionController,
              decoration: const InputDecoration(
                labelText: 'Tasa de inflación anual (%)',
                hintText: 'Ej: 8.5',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _anosController,
              decoration: const InputDecoration(
                labelText: 'Número de años',
                hintText: 'Ej: 5',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final precio = double.tryParse(_precioController.text) ?? 0;
                final tasa =
                    double.tryParse(_tasaInflacionController.text) ?? 0;
                final anos = int.tryParse(_anosController.text) ?? 0;
                controller.calcularAumentoPrecio(
                  precioActual: precio,
                  tasaInflacionAnual: tasa,
                  anos: anos,
                );
              },
              child: const Text('Calcular Aumento'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInflacionAcumuladaForm(InflacionController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _montoController,
              decoration: const InputDecoration(
                labelText: 'Monto inicial',
                hintText: 'Ej: 1000000',
                suffixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _anosController,
              decoration: const InputDecoration(
                labelText: 'Años a simular',
                hintText: 'Ej: 5',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final anos = int.tryParse(value) ?? 0;
                if (anos > _tasasAnualesControllers.length) {
                  setState(() {
                    final diferencia = anos - _tasasAnualesControllers.length;
                    for (int i = 0; i < diferencia; i++) {
                      _tasasAnualesControllers.add(TextEditingController());
                    }
                  });
                } else if (anos < _tasasAnualesControllers.length && anos > 0) {
                  setState(() {
                    _tasasAnualesControllers.removeRange(
                        anos, _tasasAnualesControllers.length);
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            if (_tasasAnualesControllers.isNotEmpty) ...[
              const Text(
                'Tasas de inflación anuales:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ..._tasasAnualesControllers.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: entry.value,
                    decoration: InputDecoration(
                      labelText: 'Año ${entry.key + 1} (%)',
                      hintText: 'Tasa de inflación',
                      suffixText: '%',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                );
              }).toList(),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final monto = double.tryParse(_montoController.text) ?? 0;
                final tasas = _tasasAnualesControllers
                    .map((c) => double.tryParse(c.text) ?? 0)
                    .toList();

                if (tasas.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Ingrese al menos una tasa de inflación')));
                  return;
                }

                controller.simularInflacionAcumulada(
                  montoInicial: monto,
                  tasasInflacionAnuales: tasas,
                );
              },
              child: const Text('Simular Inflación'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompararInversionesForm(InflacionController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _montoController,
              decoration: const InputDecoration(
                labelText: 'Monto inicial',
                hintText: 'Ej: 1000000',
                suffixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tasaInflacionController,
              decoration: const InputDecoration(
                labelText: 'Tasa de inflación anual (%)',
                hintText: 'Ej: 8.5',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _anosController,
              decoration: const InputDecoration(
                labelText: 'Número de años',
                hintText: 'Ej: 10',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tasaInversionController,
              decoration: const InputDecoration(
                labelText: 'Tasa de interés inversión (%)',
                hintText: 'Ej: 12.0',
                suffixText: '%',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _aporteAnualController,
              decoration: const InputDecoration(
                labelText: 'Aporte anual adicional (opcional)',
                hintText: 'Ej: 200000',
                suffixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final monto = double.tryParse(_montoController.text) ?? 0;
                final tasaInflacion =
                    double.tryParse(_tasaInflacionController.text) ?? 0;
                final anos = int.tryParse(_anosController.text) ?? 0;
                final tasaInversion =
                    double.tryParse(_tasaInversionController.text) ?? 0;
                final aporteAnual =
                    double.tryParse(_aporteAnualController.text);

                controller.compararEscenariosInversion(
                  montoInicial: monto,
                  tasaInflacionAnual: tasaInflacion,
                  anos: anos,
                  tasaInteresInversion: tasaInversion,
                  aportesAnuales: aporteAnual,
                );
              },
              child: const Text('Comparar Escenarios'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(InflacionController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        controller.error,
        style: const TextStyle(color: Colors.red, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildResultados(InflacionController controller) {
    if (controller.resultados is Map) {
      final resultados = controller.resultados as Map<String, dynamic>;

      if (controller.modoSeleccionado == 'Inflación acumulada' &&
          resultados is List) {
        return _buildResultadosInflacionAcumulada(resultados.values.toList());
      }

      if (controller.modoSeleccionado == 'Comparar inversiones') {
        return _buildResultadosComparacion(resultados);
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
                'Resultados - ${controller.modoSeleccionado}',
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
                            ? entry.key == 'poderAdquisitivo' ||
                                    entry.key == 'aumentoPorcentual'
                                ? '${entry.value.toStringAsFixed(2)}%'
                                : '\$${entry.value.toStringAsFixed(2)}'
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
    } else if (controller.resultados is List) {
      return _buildResultadosInflacionAcumulada(controller.resultados);
    }
    return Container();
  }

  Widget _buildResultadosInflacionAcumulada(List<dynamic> resultados) {
    return Card(
      elevation: 5,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resultados - Inflación Acumulada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Año')),
                  DataColumn(label: Text('Tasa (%)')),
                  DataColumn(label: Text('Valor Final')),
                  DataColumn(label: Text('Pérdida Anual')),
                  DataColumn(label: Text('Poder Adq. (%)')),
                ],
                rows: resultados.map((resultado) {
                  return DataRow(cells: [
                    DataCell(Text(resultado['ano'].toString())),
                    DataCell(
                        Text(resultado['tasaInflacion'].toStringAsFixed(2))),
                    DataCell(Text(
                        '\$${resultado['valorFinal'].toStringAsFixed(2)}')),
                    DataCell(Text(
                        '\$${resultado['perdidaAnual'].toStringAsFixed(2)}')),
                    DataCell(
                        Text(resultado['poderAdquisitivo'].toStringAsFixed(2))),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultadosComparacion(Map<String, dynamic> resultados) {
    final escenarios = resultados['escenarios'] as Map<String, dynamic>;

    return Card(
      elevation: 5,
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comparación de Escenarios',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Inflación acumulada en el período: ${resultados['inflacionAcumulada'].toStringAsFixed(2)}%',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ...escenarios.entries.map((escenario) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _traducirEscenario(escenario.key),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ...(escenario.value as Map<String, dynamic>)
                      .entries
                      .map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_traducirConcepto(entry.key)),
                          Text(
                            entry.key == 'poderAdquisitivo'
                                ? '${entry.value.toStringAsFixed(2)}%'
                                : '\$${entry.value.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _traducirConcepto(String key) {
    return {
          'valorFinal': 'Valor final',
          'perdida': 'Pérdida por inflación',
          'poderAdquisitivo': 'Poder adquisitivo',
          'nuevoPrecio': 'Nuevo precio',
          'aumentoAbsoluto': 'Aumento absoluto',
          'aumentoPorcentual': 'Aumento porcentual',
          'valorNominal': 'Valor nominal',
          'valorReal': 'Valor real (ajustado)',
          'ganancia': 'Ganancia real',
        }[key] ??
        key;
  }

  String _traducirEscenario(String key) {
    return {
          'guardarDinero': '1. Guardar dinero',
          'invertir': '2. Invertir dinero',
          'inversionAportes': '3. Inversión con aportes',
        }[key] ??
        key;
  }

  void _clearInputs() {
    setState(() {
      _montoController.clear();
      _tasaInflacionController.clear();
      _anosController.clear();
      _precioController.clear();
      _tasaInversionController.clear();
      _aporteAnualController.clear();
      _tasaAnualController.clear();
      _tasasAnualesControllers.clear();
    });
  }
}
