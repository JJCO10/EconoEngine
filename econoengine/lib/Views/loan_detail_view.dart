import 'package:econoengine/Controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:econoengine/Models/prestamo.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LoanDetailView extends StatelessWidget {
  final String prestamoId;

  const LoanDetailView({super.key, required this.prestamoId});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Préstamo')),
      body: StreamBuilder<Prestamo>(
        stream: authController.obtenerPrestamoPorId(prestamoId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Préstamo no encontrado.'));
          }

          final prestamo = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoItem(
                    'Monto', '\$${prestamo.monto.toStringAsFixed(2)}'),
                _buildInfoItem('Tasa de interés',
                    '${prestamo.tasaInteres.toStringAsFixed(2)}%'),
                _buildInfoItem('Tipo de interés', prestamo.tipoInteres),
                _buildInfoItem('Plazo', '${prestamo.plazoMeses} meses'),
                _buildInfoItem('Estado', prestamo.estado),
                _buildInfoItem(
                  'Fecha solicitud',
                  DateFormat('dd/MM/yyyy')
                      .format(prestamo.fechaSolicitud.toDate()),
                ),
                _buildInfoItem('Saldo pendiente',
                    '\$${prestamo.saldoPendiente.toStringAsFixed(2)}'),
                _buildInfoItem('Total pagado',
                    '\$${prestamo.totalPagado.toStringAsFixed(2)}'),
                const SizedBox(height: 20),
                const Text('Cuotas',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...prestamo.cuotas.map((cuota) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text('Cuota ${cuota.numero}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vence: ${DateFormat('dd/MM/yyyy').format(cuota.fechaVencimiento.toDate())}',
                          ),
                          Text('Monto: \$${cuota.monto.toStringAsFixed(2)}'),
                          Text('Estado: ${cuota.estado}'),
                        ],
                      ),
                      trailing: prestamo.estado == 'pendiente' &&
                              prestamo.estado != 'aprobado'
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.payment),
                              onPressed: cuota.estado == 'pagada'
                                  ? null
                                  : () {
                                      _pagarCuota(
                                          context, prestamo.id, cuota.numero);
                                    },
                              tooltip: cuota.estado == 'pagada'
                                  ? 'Cuota ya pagada'
                                  : 'Pagar cuota',
                              color: cuota.estado == 'pagada'
                                  ? Colors.grey
                                  : Colors.blue,
                            ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  void _pagarCuota(BuildContext context, String prestamoId, int numeroCuota) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pagar Cuota'),
          content: Text('¿Deseas pagar la cuota #$numeroCuota?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await Provider.of<AuthController>(context, listen: false)
                      .pagarCuota(prestamoId, numeroCuota);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cuota pagada exitosamente')),
                  );
                  Navigator.pop(context); // Cierra el dialog
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Pagar'),
            ),
          ],
        );
      },
    );
  }
}
