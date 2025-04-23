import 'package:econoengine/Controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:econoengine/Models/prestamo.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LoanDetailView extends StatelessWidget {
  final Prestamo prestamo;

  const LoanDetailView({super.key, required this.prestamo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Préstamo #${prestamo.id.substring(0, 6)}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem('Monto', '\$${prestamo.monto.toStringAsFixed(2)}'),
            _buildInfoItem('Tasa de interés',
                '${prestamo.tasaInteres.toStringAsFixed(2)}%'),
            _buildInfoItem('Tipo de interés', prestamo.tipoInteres),
            _buildInfoItem('Plazo', '${prestamo.plazoMeses} meses'),
            _buildInfoItem('Estado', prestamo.estado),
            _buildInfoItem(
                'Fecha solicitud',
                DateFormat('dd/MM/yyyy')
                    .format(prestamo.fechaSolicitud.toDate())),
            _buildInfoItem('Saldo pendiente',
                '\$${prestamo.saldoPendiente.toStringAsFixed(2)}'),
            _buildInfoItem(
                'Total pagado', '\$${prestamo.totalPagado.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            const Text('Cuotas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...prestamo.cuotas.map((cuota) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text('Cuota ${cuota.numero}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Vence: ${DateFormat('dd/MM/yyyy').format(cuota.fechaVencimiento.toDate())}'),
                      Text('Monto: \$${cuota.monto.toStringAsFixed(2)}'),
                      Text('Estado: ${cuota.estado}'),
                    ],
                  ),
                  trailing: cuota.estado == 'pendiente'
                      ? IconButton(
                          icon: const Icon(Icons.payment),
                          onPressed: () {
                            // Implementar pago de cuota
                            _pagarCuota(context, cuota.numero);
                          },
                        )
                      : null,
                ),
              );
            }).toList(),
          ],
        ),
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

  void _pagarCuota(BuildContext context, int numeroCuota) {
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
                  // Implementar lógica de pago
                  await Provider.of<AuthController>(context, listen: false)
                      .pagarCuota(prestamo.id, numeroCuota);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cuota pagada exitosamente')),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context); // Volver a la lista de préstamos
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
