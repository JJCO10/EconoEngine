import 'package:econoengine/Views/loan_detail_view.dart';
import 'package:econoengine/Views/loan_request_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:econoengine/Controllers/auth_controller.dart';
import 'package:econoengine/Models/prestamo.dart';
import 'package:intl/intl.dart';

class LoansListView extends StatelessWidget {
  const LoansListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Préstamos')),
      body: FutureBuilder<List<Prestamo>>(
        future: Provider.of<AuthController>(context, listen: false)
            .obtenerPrestamosUsuario(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final prestamos = snapshot.data ?? [];

          if (prestamos.isEmpty) {
            return const Center(child: Text('No tienes préstamos'));
          }

          return ListView.builder(
            itemCount: prestamos.length,
            itemBuilder: (context, index) {
              final prestamo = prestamos[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('\$${prestamo.monto.toStringAsFixed(2)}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estado: ${prestamo.estado}'),
                      Text(
                          'Fecha: ${DateFormat('dd/MM/yyyy').format(prestamo.fechaSolicitud.toDate())}'),
                      Text(
                          'Saldo: \$${prestamo.saldoPendiente.toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoanDetailView(prestamo: prestamo),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoanRequestView()),
          );
        },
      ),
    );
  }
}
