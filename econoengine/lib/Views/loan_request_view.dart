import 'package:econoengine/Models/cuota.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:econoengine/Controllers/auth_controller.dart';

class LoanRequestView extends StatefulWidget {
  const LoanRequestView({super.key});

  @override
  _LoanRequestViewState createState() => _LoanRequestViewState();
}

class _LoanRequestViewState extends State<LoanRequestView> {
  final _formKey = GlobalKey<FormState>();
  double _monto = 0;
  double _tasaInteres = 1.5;
  double _plazo = 12;
  String _tipoPlazo = 'meses'; // mes o año
  String _tipoInteres = 'simple';
  // Nuevos campos para gradiente y amortización
  String _tipoGradiente = 'aritmético';
  String _tipoAmortizacion = 'francés';
  double _valorGradiente = 10.0; // valor por defecto
  List<Cuota> _cuotasSimuladas = [];

  // Usuario datos desde Firestore
  String _telefono = '';
  String _cedula = '';
  String _nombre = '';
  double _saldoUsuario = 0;

  @override
  void initState() {
    super.initState();
    _obtenerDatosUsuario();
  }

  Future<void> _obtenerDatosUsuario() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final userId = await authController.getAuthState();

    if (userId != null) {
      try {
        final userData = await authController.getUserData(userId);
        setState(() {
          _telefono = userData['Telefono'] ?? '';
          _cedula = userData['Numero Documento'] ?? '';
          _nombre = userData['Nombre'] ?? '';
          _saldoUsuario = userData['Saldo'] ?? 0; // Obtener el saldo
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener datos: ${e.toString()}')),
        );
      }
    }
  }

  void _calcularSimulacion() {
    if (_formKey.currentState?.validate() ?? false) {
      final authController =
          Provider.of<AuthController>(context, listen: false);

      // Convertir plazo a meses si está en años
      final plazoMeses =
          _tipoPlazo == 'meses' ? _plazo.toInt() : (_plazo.toInt() * 12);

      try {
        final cuotas = authController.calcularCuotasPrestamo(
          monto: _monto,
          tasaAnual: _tasaInteres,
          plazoMeses: plazoMeses,
          tipoInteres: _tipoInteres,
          tipoGradiente: _tipoGradiente, // Pasamos el tipo de gradiente
          tipoAmortizacion:
              _tipoAmortizacion, // Pasamos el tipo de amortización
          valorGradiente: _valorGradiente, // Pasamos el valor del gradiente
        );

        setState(() {
          _cuotasSimuladas = cuotas;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en la simulación: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _solicitarPrestamo() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authController =
            Provider.of<AuthController>(context, listen: false);
        final plazoMeses =
            _tipoPlazo == 'meses' ? _plazo.toInt() : (_plazo.toInt() * 12);

        // Determinar el estado basado en el saldo
        final estadoPrestamo = _saldoUsuario >= _monto * 0.1
            ? 'aprobado'
            : 'en estudio'; // Cambiado de 'pendiente' a 'en estudio'

        await authController.solicitarPrestamo(
          monto: _monto,
          tipoInteres: _tipoInteres,
          tasaInteres: _tasaInteres,
          plazoMeses: plazoMeses,
          destinoTelefono: _telefono,
          solicitanteCedula: _cedula,
          solicitanteNombre: _nombre,
          estado: estadoPrestamo,
          tipoGradiente: _tipoInteres == 'gradiente' ? _tipoGradiente : null,
          tipoAmortizacion:
              _tipoInteres == 'amortizacion' ? _tipoAmortizacion : null,
          valorGradiente: _tipoInteres == 'gradiente' ? _valorGradiente : null,
        );

        // Solo actualizar saldo si es aprobado
        if (estadoPrestamo == 'aprobado') {
          final nuevoSaldo = _saldoUsuario + _monto;
          await authController.actualizarSaldoUsuario(nuevoSaldo);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Préstamo aprobado y saldo actualizado'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Préstamo enviado a estudio'),
            ),
          );
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Préstamo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Información del usuario
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Solicitante: $_nombre',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Cédula: $_cedula'),
                      Text('Teléfono: $_telefono'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Formulario de solicitud
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Detalles del Préstamo',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Monto del préstamo',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              double.tryParse(value) == null ||
                              double.parse(value) <= 0) {
                            return 'Ingrese un monto válido';
                          }
                          return null;
                        },
                        onChanged: (value) => setState(() {
                          _monto = double.tryParse(value) ?? 0;
                        }),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _tipoInteres,
                        decoration: const InputDecoration(
                          labelText: 'Tipo de interés',
                          prefixIcon: Icon(Icons.percent),
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(
                              value: 'simple', child: Text('Interés Simple')),
                          DropdownMenuItem(
                              value: 'compuesto',
                              child: Text('Interés Compuesto')),
                          DropdownMenuItem(
                              value: 'gradiente', child: Text('Gradiente')),
                          DropdownMenuItem(
                              value: 'amortizacion',
                              child: Text('Amortización')),
                        ],
                        onChanged: (value) =>
                            setState(() => _tipoInteres = value!),
                      ),

                      // Opciones adicionales para Gradiente
                      if (_tipoInteres == 'gradiente') ...[
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _tipoGradiente,
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Gradiente',
                            prefixIcon: Icon(Icons.trending_up),
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(
                                value: 'aritmético', child: Text('Aritmético')),
                            DropdownMenuItem(
                                value: 'geométrico', child: Text('Geométrico')),
                          ],
                          onChanged: (value) =>
                              setState(() => _tipoGradiente = value!),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _tipoGradiente == 'aritmético'
                                  ? 'Valor del Gradiente'
                                  : 'Tasa de Crecimiento (%)',
                              style: TextStyle(fontSize: 16),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: _valorGradiente,
                                    min: 0,
                                    max: _tipoGradiente == 'aritmético'
                                        ? 100
                                        : 20,
                                    divisions: _tipoGradiente == 'aritmético'
                                        ? 100
                                        : 20,
                                    label: _valorGradiente.toStringAsFixed(1),
                                    onChanged: (value) =>
                                        setState(() => _valorGradiente = value),
                                  ),
                                ),
                                Container(
                                  width: 60,
                                  child: Text(_tipoGradiente == 'aritmético'
                                      ? '${_valorGradiente.toStringAsFixed(1)}'
                                      : '${_valorGradiente.toStringAsFixed(1)}%'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],

                      // Opciones adicionales para Amortización
                      if (_tipoInteres == 'amortizacion') ...[
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _tipoAmortizacion,
                          decoration: const InputDecoration(
                            labelText: 'Sistema de Amortización',
                            prefixIcon: Icon(Icons.account_balance),
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(
                                value: 'francés',
                                child: Text('Sistema Francés')),
                            DropdownMenuItem(
                                value: 'alemán', child: Text('Sistema Alemán')),
                            DropdownMenuItem(
                                value: 'americano',
                                child: Text('Sistema Americano')),
                          ],
                          onChanged: (value) =>
                              setState(() => _tipoAmortizacion = value!),
                        ),
                      ],

                      const SizedBox(height: 16),
                      const Text('Tasa de interés anual'),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _tasaInteres,
                              min: 0,
                              max: 30,
                              divisions: 300,
                              label: '${_tasaInteres.toStringAsFixed(1)}%',
                              onChanged: (value) =>
                                  setState(() => _tasaInteres = value),
                            ),
                          ),
                          Container(
                            width: 60,
                            child: Text('${_tasaInteres.toStringAsFixed(1)}%'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Plazo'),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _plazo,
                              min: _tipoPlazo == 'meses' ? 1 : 1,
                              max: _tipoPlazo == 'meses' ? 60 : 5,
                              divisions: _tipoPlazo == 'meses' ? 59 : 4,
                              label: _tipoPlazo == 'meses'
                                  ? '${_plazo.toInt()} meses'
                                  : '${_plazo.toInt()} años',
                              onChanged: (value) =>
                                  setState(() => _plazo = value),
                            ),
                          ),
                          DropdownButton<String>(
                            value: _tipoPlazo,
                            items: const [
                              DropdownMenuItem(
                                  value: 'meses', child: Text('Meses')),
                              DropdownMenuItem(
                                  value: 'años', child: Text('Años')),
                            ],
                            onChanged: (value) => setState(() {
                              _tipoPlazo = value!;
                              _plazo = _tipoPlazo == 'meses' ? 12 : 1;
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.calculate),
                label: const Text('Simular Préstamo'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _calcularSimulacion,
              ),

              if (_cuotasSimuladas.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text('Plan de Pagos',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Cuota')),
                      DataColumn(label: Text('Fecha')),
                      DataColumn(label: Text('Monto')),
                      DataColumn(label: Text('Capital')),
                      DataColumn(label: Text('Interés')),
                    ],
                    rows: _cuotasSimuladas.map((cuota) {
                      return DataRow(cells: [
                        DataCell(Text(cuota.numero.toString())),
                        DataCell(Text(DateFormat('dd/MM/yyyy')
                            .format(cuota.fechaVencimiento.toDate()))),
                        DataCell(Text('\$${cuota.monto.toStringAsFixed(2)}')),
                        DataCell(Text('\$${cuota.capital.toStringAsFixed(2)}')),
                        DataCell(Text('\$${cuota.interes.toStringAsFixed(2)}')),
                      ]);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('Solicitar Préstamo'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _solicitarPrestamo,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
