import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Controllers/uvr_controller.dart';

class UvrView extends StatefulWidget {
  const UvrView({super.key});

  @override
  State<UvrView> createState() => _UvrViewState();
}

class _UvrViewState extends State<UvrView> {
  final TextEditingController _valorInicialController = TextEditingController();
  final TextEditingController _valorFinalController = TextEditingController();
  final TextEditingController _valorPesosController = TextEditingController();
  final TextEditingController _valorUvrController = TextEditingController();
  final TextEditingController _montoUvrController = TextEditingController();
  final TextEditingController _tasaInteresController = TextEditingController();
  final TextEditingController _plazoMesesController = TextEditingController();
  final TextEditingController _inflacionController = TextEditingController();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _cuotaInicialController = TextEditingController();

  DateTime _fechaInicial = DateTime.now();
  DateTime _fechaFinal = DateTime.now().add(const Duration(days: 30));
  DateTime _fechaActual = DateTime.now();
  DateTime _fechaProyeccion = DateTime.now().add(const Duration(days: 365));

  @override
  void dispose() {
    _valorInicialController.dispose();
    _valorFinalController.dispose();
    _valorPesosController.dispose();
    _valorUvrController.dispose();
    _montoUvrController.dispose();
    _tasaInteresController.dispose();
    _plazoMesesController.dispose();
    _inflacionController.dispose();
    _capitalController.dispose();
    _cuotaInicialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<UvrController>(context);
    final modos = [
      'Variación UVR',
      'Convertir Pesos a UVR',
      'Convertir UVR a Pesos',
      'Calcular Cuota Crédito UVR',
      'Proyectar UVR',
      'Tabla Amortización UVR'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora UVR'),
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
            if (controller.tieneResultado) _buildResultado(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildModoSelector(UvrController controller, List<String> modos) {
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

  Widget _buildFormByModo(UvrController controller) {
    switch (controller.modoSeleccionado) {
      case 'Variación UVR':
        return _buildVariacionUvrForm(controller);
      case 'Convertir Pesos a UVR':
        return _buildPesosAUvrForm(controller);
      case 'Convertir UVR a Pesos':
        return _buildUvrAPesosForm(controller);
      case 'Calcular Cuota Crédito UVR':
        return _buildCuotaCreditoForm(controller);
      case 'Proyectar UVR':
        return _buildProyectarUvrForm(controller);
      case 'Tabla Amortización UVR':
        return _buildTablaAmortizacionForm(controller);
      default:
        return Container();
    }
  }

  Widget _buildVariacionUvrForm(UvrController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _valorInicialController,
              decoration: const InputDecoration(
                labelText: 'Valor inicial UVR',
                hintText: 'Ej: 300.50',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _valorFinalController,
              decoration: const InputDecoration(
                labelText: 'Valor final UVR',
                hintText: 'Ej: 310.25',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            _buildDatePicker(
              'Fecha inicial',
              _fechaInicial,
              (date) => setState(() => _fechaInicial = date),
            ),
            const SizedBox(height: 10),
            _buildDatePicker(
              'Fecha final',
              _fechaFinal,
              (date) => setState(() => _fechaFinal = date),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final valorInicial =
                    double.tryParse(_valorInicialController.text) ?? 0;
                final valorFinal =
                    double.tryParse(_valorFinalController.text) ?? 0;
                controller.calcularVariacionUvr(
                  valorInicial,
                  valorFinal,
                  _fechaInicial,
                  _fechaFinal,
                );
              },
              child: const Text('Calcular Variación'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPesosAUvrForm(UvrController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _valorPesosController,
              decoration: const InputDecoration(
                labelText: 'Valor en Pesos',
                hintText: 'Ej: 1000000',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _valorUvrController,
              decoration: const InputDecoration(
                labelText: 'Valor actual UVR',
                hintText: 'Ej: 320.50',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final valorPesos =
                    double.tryParse(_valorPesosController.text) ?? 0;
                final valorUvr = double.tryParse(_valorUvrController.text) ?? 0;
                controller.convertirPesosAUvr(valorPesos, valorUvr);
              },
              child: const Text('Convertir a UVR'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUvrAPesosForm(UvrController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _valorUvrController,
              decoration: const InputDecoration(
                labelText: 'Valor en UVR',
                hintText: 'Ej: 3000',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _valorFinalController,
              decoration: const InputDecoration(
                labelText: 'Valor actual UVR',
                hintText: 'Ej: 320.50',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final valorUvr = double.tryParse(_valorUvrController.text) ?? 0;
                final valorActualUvr =
                    double.tryParse(_valorFinalController.text) ?? 0;
                controller.convertirUvrAPesos(valorUvr, valorActualUvr);
              },
              child: const Text('Convertir a Pesos'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCuotaCreditoForm(UvrController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _montoUvrController,
              decoration: const InputDecoration(
                labelText: 'Monto del crédito en UVR',
                hintText: 'Ej: 3000',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tasaInteresController,
              decoration: const InputDecoration(
                labelText: 'Tasa de interés EA (%)',
                hintText: 'Ej: 10 (para 10%)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _plazoMesesController,
              decoration: const InputDecoration(
                labelText: 'Plazo en meses',
                hintText: 'Ej: 36',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _valorUvrController,
              decoration: const InputDecoration(
                labelText: 'Valor actual UVR',
                hintText: 'Ej: 320.50',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final montoUvr = double.tryParse(_montoUvrController.text) ?? 0;
                final tasaInteres =
                    double.tryParse(_tasaInteresController.text) ?? 0;
                final plazoMeses =
                    int.tryParse(_plazoMesesController.text) ?? 0;
                final valorUvr = double.tryParse(_valorUvrController.text) ?? 0;
                controller.calcularCuotaCreditoUvr(
                  montoUvr,
                  tasaInteres / 100,
                  plazoMeses,
                  valorUvr,
                );
              },
              child: const Text('Calcular Cuota'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProyectarUvrForm(UvrController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _valorUvrController,
              decoration: const InputDecoration(
                labelText: 'Valor actual UVR',
                hintText: 'Ej: 320.50',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _inflacionController,
              decoration: const InputDecoration(
                labelText: 'Inflación anual proyectada (%)',
                hintText: 'Ej: 5 (para 5%)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            _buildDatePicker(
              'Fecha actual',
              _fechaActual,
              (date) => setState(() => _fechaActual = date),
            ),
            const SizedBox(height: 10),
            _buildDatePicker(
              'Fecha de proyección',
              _fechaProyeccion,
              (date) => setState(() => _fechaProyeccion = date),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final valorUvr = double.tryParse(_valorUvrController.text) ?? 0;
                final inflacion =
                    double.tryParse(_inflacionController.text) ?? 0;
                controller.proyectarUvr(
                  valorUvr,
                  inflacion / 100,
                  _fechaActual,
                  _fechaProyeccion,
                );
              },
              child: const Text('Proyectar UVR'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTablaAmortizacionForm(UvrController controller) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _capitalController,
              decoration: const InputDecoration(
                labelText: 'Capital del crédito (Pesos)',
                hintText: 'Ej: 100000000',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cuotaInicialController,
              decoration: const InputDecoration(
                labelText: 'Cuota inicial (Pesos)',
                hintText: 'Ej: 20000000 (opcional)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _valorUvrController,
              decoration: const InputDecoration(
                labelText: 'Valor actual UVR',
                hintText: 'Ej: 320.50',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tasaInteresController,
              decoration: const InputDecoration(
                labelText: 'Tasa de interés EA (%)',
                hintText: 'Ej: 10 (para 10%)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _plazoMesesController,
              decoration: const InputDecoration(
                labelText: 'Plazo en meses',
                hintText: 'Ej: 36',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _inflacionController,
              decoration: const InputDecoration(
                labelText: 'Inflación anual proyectada (%)',
                hintText: 'Ej: 5 (para 5%)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final capital = double.tryParse(_capitalController.text) ?? 0;
                final cuotaInicial =
                    double.tryParse(_cuotaInicialController.text) ?? 0;
                final valorUvr = double.tryParse(_valorUvrController.text) ?? 0;
                final tasaInteres =
                    double.tryParse(_tasaInteresController.text) ?? 0;
                final plazoMeses =
                    int.tryParse(_plazoMesesController.text) ?? 0;
                final inflacion =
                    double.tryParse(_inflacionController.text) ?? 0;
                controller.generarTablaAmortizacionUvr(
                  capital,
                  cuotaInicial,
                  valorUvr,
                  tasaInteres / 100,
                  plazoMeses,
                  inflacion / 100,
                );
              },
              child: const Text('Generar Tabla'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(
      String label, DateTime date, ValueChanged<DateTime> onChanged) {
    return ListTile(
      title: Text('$label: ${DateFormat('dd/MM/yyyy').format(date)}'),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          onChanged(selectedDate);
        }
      },
    );
  }

  Widget _buildError(UvrController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        controller.error,
        style: const TextStyle(color: Colors.red, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildResultado(UvrController controller) {
    if (controller.modoSeleccionado == 'Tabla Amortización UVR') {
      return _buildTablaAmortizacionResult(controller.resultado);
    }

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
            if (controller.resultado is Map)
              ..._buildMapResult(controller.resultado)
            else
              Text(
                '${(controller.resultado * 100).toStringAsFixed(2)}%',
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

  List<Widget> _buildMapResult(Map<dynamic, dynamic> result) {
    return result.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${entry.key}:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              entry.value is double
                  ? entry.value.toStringAsFixed(2)
                  : entry.value.toString(),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildTablaAmortizacionResult(dynamic resultado) {
    // Verificar si el resultado tiene la estructura esperada
    if (resultado == null || resultado['tabla'] == null) {
      return const Text('No hay datos de tabla para mostrar');
    }

    final resumen = resultado['resumen'] as Map<String, dynamic>;
    final tabla = resultado['tabla'] as List<Map<String, dynamic>>;

    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen del Crédito',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...resumen.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(entry.value.toString()),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
            const Text(
              'Tabla de Amortización',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('Mes')),
                  DataColumn(
                      label: Text('Valor UVR', textAlign: TextAlign.right)),
                  DataColumn(
                      label: Text('Cuota UVR', textAlign: TextAlign.right)),
                  DataColumn(
                      label: Text('Interés UVR', textAlign: TextAlign.right)),
                  DataColumn(
                      label: Text('Abono UVR', textAlign: TextAlign.right)),
                  DataColumn(
                      label: Text('Saldo UVR', textAlign: TextAlign.right)),
                  DataColumn(
                      label: Text('Cuota \$', textAlign: TextAlign.right)),
                  DataColumn(
                      label: Text('Interés \$', textAlign: TextAlign.right)),
                  DataColumn(
                      label: Text('Abono \$', textAlign: TextAlign.right)),
                  DataColumn(
                      label: Text('Saldo \$', textAlign: TextAlign.right)),
                ],
                rows: tabla.map((fila) {
                  return DataRow(cells: [
                    DataCell(Text(fila['Mes'].toString())),
                    DataCell(Text(fila['Valor UVR'])),
                    DataCell(Text(fila['Cuota UVR'])),
                    DataCell(Text(fila['Interés UVR'])),
                    DataCell(Text(fila['Abono Capital UVR'])),
                    DataCell(Text(fila['Saldo UVR'])),
                    DataCell(Text(fila['Cuota Pesos'])),
                    DataCell(Text(fila['Interés Pesos'])),
                    DataCell(Text(fila['Abono Capital Pesos'])),
                    DataCell(Text(fila['Saldo Pesos'])),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearInputs() {
    setState(() {
      _valorInicialController.clear();
      _valorFinalController.clear();
      _valorPesosController.clear();
      _valorUvrController.clear();
      _montoUvrController.clear();
      _tasaInteresController.clear();
      _plazoMesesController.clear();
      _inflacionController.clear();
      _capitalController.clear();
      _cuotaInicialController.clear();
    });
  }
}
