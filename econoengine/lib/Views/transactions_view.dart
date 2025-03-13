import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TransactionsView extends StatefulWidget {
  const TransactionsView({super.key});

  @override
  State<TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<TransactionsView> {
  final int _movimientosPorCarga = 10; // Número de movimientos por carga
  final List<DocumentSnapshot> _movimientos = []; // Lista de movimientos
  bool _cargandoMas = false; // Indicador de carga

  Future<void> _cargarMovimientos() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Obtener el número de documento del usuario desde Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception('No se encontró el usuario en Firestore');
    }

    final numeroDocumento = userDoc.data()?['Numero Documento'] as String?;
    if (numeroDocumento == null) {
      throw Exception('Número de documento no encontrado');
    }

    // Consultar las transferencias usando el número de documento
    final query = FirebaseFirestore.instance
        .collection('transferencias')
        .where('destinatarioCedula', isEqualTo: numeroDocumento) // Cambiar 'remitenteCedula' por 'destinatarioCedula'
        .orderBy('fechaHora', descending: true) // Ordenar por fechaHora
        .limit(_movimientosPorCarga);

    final snapshot = await query.get();
    setState(() {
      _movimientos.addAll(snapshot.docs);
    });
  }

  Future<void> _cargarMasMovimientos() async {
    if (_cargandoMas || _movimientos.isEmpty) return; // Verificar si la lista está vacía

    setState(() {
      _cargandoMas = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Obtener el número de documento del usuario desde Firestore
    final userDoc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception('No se encontró el usuario en Firestore');
    }

    final numeroDocumento = userDoc.data()?['Numero Documento'] as String?;
    if (numeroDocumento == null) {
      throw Exception('Número de documento no encontrado');
    }

    // Consultar las transferencias usando el número de documento
    final query = FirebaseFirestore.instance
        .collection('transferencias')
        .where('destinatarioCedula', isEqualTo: numeroDocumento) // Cambiar 'remitenteCedula' por 'destinatarioCedula'
        .orderBy('fechaHora', descending: true) // Ordenar por fechaHora
        .startAfterDocument(_movimientos.last)
        .limit(_movimientosPorCarga);

    final snapshot = await query.get();
    setState(() {
      _movimientos.addAll(snapshot.docs);
      _cargandoMas = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarMovimientos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimientos'),
      ),
      body: ListView.builder(
        itemCount: _movimientos.length + 1, // +1 para el botón de cargar más
        itemBuilder: (context, index) {
          if (index < _movimientos.length) {
            final movimiento = _movimientos[index].data() as Map<String, dynamic>;
            final tipo = movimiento['tipo'] as String;
            final nombre = tipo == 'envio'
                ? movimiento['destinatario']['nombre']
                : movimiento['remitente']['nombre'];
            final monto = movimiento['monto'] as double;
            final fecha = DateTime.parse(movimiento['fecha'] as String);

            return ListTile(
              leading: Icon(
                tipo == 'envio' ? Icons.arrow_downward : Icons.arrow_upward,
                color: tipo == 'envio' ? Colors.red : Colors.green,
              ),
              title: Text(
                tipo == 'envio' ? 'Enviado a $nombre' : 'Recibido de $nombre',
                style: TextStyle(
                  color: tipo == 'envio' ? Colors.red : Colors.black,
                ),
              ),
              subtitle: Text(
                '\$${monto.toStringAsFixed(2)} - ${DateFormat('dd/MM/yyyy HH:mm').format(fecha)}',
              ),
              onTap: () {
                _mostrarDetallesTransferencia(context, movimiento);
              },
            );
          } else {
            return _cargandoMas
                ? const Center(child: CircularProgressIndicator())
                : TextButton(
                    onPressed: _cargarMasMovimientos,
                    child: const Text('Cargar más movimientos'),
                  );
          }
        },
      ),
    );
  }

  void _mostrarDetallesTransferencia(BuildContext context, Map<String, dynamic> transferencia) {
    final tipo = transferencia['tipo'] as String;
    final remitente = transferencia['remitente'] as Map<String, dynamic>;
    final destinatario = transferencia['destinatario'] as Map<String, dynamic>;
    final monto = transferencia['monto'] as double;
    final fecha = DateTime.parse(transferencia['fecha'] as String);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(tipo == 'envio' ? 'Detalles del envío' : 'Detalles de la recepción'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Remitente: ${remitente['nombre']}'),
              Text('Teléfono: ${remitente['telefono']}'),
              Text('Cédula: ${remitente['cedula']}'),
              const SizedBox(height: 10),
              Text('Destinatario: ${destinatario['nombre']}'),
              Text('Teléfono: ${destinatario['telefono']}'),
              Text('Cédula: ${destinatario['cedula']}'),
              const SizedBox(height: 10),
              Text('Monto: \$${monto.toStringAsFixed(2)}'),
              Text('Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(fecha)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}