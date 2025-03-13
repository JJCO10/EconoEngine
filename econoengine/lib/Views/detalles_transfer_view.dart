import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:econoengine/Models/transferencia.dart';

class DetallesTransferenciaView extends StatelessWidget {
  final Transferencia transferencia;

  const DetallesTransferenciaView({super.key, required this.transferencia});

  @override
  Widget build(BuildContext context) {
    final esEnvio = transferencia.userId == FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEnvio ? 'Detalles del envío' : 'Detalles de la recepción'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Remitente: ${transferencia.remitenteNombre}',
                style: const TextStyle(fontSize: 16)),
            Text('Teléfono: ${transferencia.remitenteCelular}',
                style: const TextStyle(fontSize: 16)),
            Text('Cédula: ${transferencia.remitenteCedula}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Text('Destinatario: ${transferencia.destinatarioNombre}',
                style: const TextStyle(fontSize: 16)),
            Text('Teléfono: ${transferencia.destinatarioCelular}',
                style: const TextStyle(fontSize: 16)),
            Text('Cédula: ${transferencia.destinatarioCedula}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Text('Monto: \$${_formatearSaldo(transferencia.monto)}',
                style: const TextStyle(fontSize: 16)),
            Text('Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(transferencia.fechaHora)}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Método para formatear el saldo
  String _formatearSaldo(double saldo) {
    final formatter = NumberFormat("#,##0.00", "es_ES"); // Formateador
    return formatter.format(saldo);
  }
}