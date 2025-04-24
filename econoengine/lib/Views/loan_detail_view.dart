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

          return FutureBuilder<bool>(
            future: authController.puedePagarPrestamoCompleto(prestamo.id),
            builder: (context, saldoSnapshot) {
              final puedePagar = saldoSnapshot.data ?? false;

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
                    // Botón para pagar el préstamo completo
                    if (prestamo.estado.trim().toLowerCase() != 'pagado' &&
                        prestamo.estado.trim().toLowerCase() != 'en estudio')
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.payment),
                          label: const Text('Pagar Préstamo Completo'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            backgroundColor:
                                puedePagar ? Colors.green : Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: puedePagar
                              ? () =>
                                  _pagarPrestamoCompleto(context, prestamo.id)
                              : null,
                        ),
                      ),
                    const SizedBox(height: 20),
                    const Text('Cuotas',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
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
                              Text(
                                  'Monto: \$${cuota.monto.toStringAsFixed(2)}'),
                              Text('Estado: ${cuota.estado}'),
                            ],
                          ),
                          trailing: (prestamo.estado.trim().toLowerCase() ==
                                      'en estudio' ||
                                  cuota.estado.toLowerCase() == 'pagada')
                              ? IconButton(
                                  icon: const Icon(Icons.payment),
                                  onPressed: null, // deshabilitado
                                  tooltip:
                                      cuota.estado.toLowerCase() == 'pagada'
                                          ? 'Cuota ya pagada'
                                          : 'Préstamo en estudio',
                                  color: Colors.grey,
                                )
                              : IconButton(
                                  icon: const Icon(Icons.payment),
                                  onPressed: () {
                                    _pagarCuota(
                                        context, prestamo.id, cuota.numero);
                                  },
                                  tooltip: 'Pagar cuota',
                                  color: Colors.blue,
                                ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Método para manejar el pago completo
void _pagarPrestamoCompleto(BuildContext context, String prestamoId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Pagar Préstamo Completo'),
        content: const Text(
            '¿Estás seguro de que deseas pagar el préstamo completo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<AuthController>(context, listen: false)
                    .pagarPrestamoCompleto(prestamoId);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Préstamo pagado exitosamente')),
                );
                Navigator.pop(context); // Cierra el dialog
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Error al pagar el préstamo: ${e.toString()}')),
                );
              }
            },
            child: const Text('Pagar Todo'),
          ),
        ],
      );
    },
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
