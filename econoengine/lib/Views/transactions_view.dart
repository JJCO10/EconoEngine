import 'package:econoengine/Models/transferencia.dart';
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
  final List<Transferencia> _movimientos = []; // Lista de movimientos
  bool _cargandoMas = false; // Indicador de carga
  bool _hayMasMovimientos = true; // Indica si hay más movimientos por cargar

  Future<void> _cargarMovimientos({bool cargarMas = false}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Obtener los datos del usuario desde Firestore
    final userDocRef =
        FirebaseFirestore.instance.collection('usuarios').doc(user.uid);
    final userDoc =
        await userDocRef.get(); // Esta es la variable que estaba faltando

    if (!userDoc.exists) {
      throw Exception('Documento del usuario no encontrado');
    }

    final numeroDocumento = userDoc.data()?['Numero Documento'] as String?;
    if (numeroDocumento == null) {
      throw Exception('Número de documento no encontrado');
    }

    final query = FirebaseFirestore.instance
        .collection('transferencias')
        .where(Filter.or(
          Filter('userId',
              isEqualTo: user.uid), // Transacciones enviadas por el usuario
          Filter('destinatarioCedula',
              isEqualTo: numeroDocumento), // Transacciones recibidas
        )) // Filtra tanto envíos como recepciones
        .orderBy('fechaHora', descending: true)
        .limit(_movimientosPorCarga);

    QuerySnapshot snapshot;

    if (cargarMas && _movimientos.isNotEmpty) {
      // Si cargamos más, empezamos después del último movimiento ya mostrado
      snapshot = await query.startAfter([_movimientos.last.fechaHora]).get();
    } else {
      // Cargar los primeros movimientos
      snapshot = await query.get();
      _movimientos.clear();
    }

    setState(() {
      _movimientos.addAll(
        snapshot.docs.map(
            (doc) => Transferencia.fromMap(doc.data() as Map<String, dynamic>)),
      );
      _cargandoMas = false;
      _hayMasMovimientos = snapshot.docs.length == _movimientosPorCarga;
    });
  }

  Future<void> _cargarMasMovimientos() async {
    if (_cargandoMas || _movimientos.isEmpty || !_hayMasMovimientos)
      return; // Verificar si la lista está vacía

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
        .where('userId', isEqualTo: user.uid) // Filtra por destinatario
        .orderBy('fechaHora', descending: true) // Ordena por fechaHora
        .startAfter([
      _movimientos.last.fechaHora
    ]) // Usa la fechaHora del último movimiento
        .limit(_movimientosPorCarga);

    final snapshot = await query.get();
    setState(() {
      _movimientos.addAll(
        snapshot.docs.map((doc) => Transferencia.fromMap(doc.data())),
      );
      _cargandoMas = false;
      _hayMasMovimientos = snapshot.docs.length == _movimientosPorCarga;
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
        itemCount: _movimientos.length +
            (_hayMasMovimientos ? 1 : 0), // +1 para el botón de cargar más
        itemBuilder: (context, index) {
          if (index < _movimientos.length) {
            final transferencia = _movimientos[index];
            final esEnvio =
                transferencia.userId == FirebaseAuth.instance.currentUser?.uid;

            return ListTile(
              leading: Icon(
                esEnvio ? Icons.arrow_downward : Icons.arrow_upward,
                color: esEnvio ? Colors.red : Colors.green,
              ),
              title: Text(
                esEnvio
                    ? 'Enviado a ${transferencia.destinatarioNombre}'
                    : 'Recibido de ${transferencia.remitenteNombre}',
                style: TextStyle(
                  color: esEnvio
                      ? Colors.red
                      : (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                ),
              ),
              subtitle: Text(
                '\$${_formatearSaldo(transferencia.monto)} - ${DateFormat('dd/MM/yyyy HH:mm').format(transferencia.fechaHora)}',
              ),
              onTap: () {
                _mostrarDetallesTransferencia(context, transferencia);
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

  // Método para formatear el saldo
  String _formatearSaldo(double saldo) {
    final formatter = NumberFormat("#,##0.00", "es_ES"); // Formateador
    return formatter.format(saldo);
  }

  void _mostrarDetallesTransferencia(
      BuildContext context, Transferencia transferencia) {
    final esEnvio =
        transferencia.userId == FirebaseAuth.instance.currentUser?.uid;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text(esEnvio ? 'Detalles del envío' : 'Detalles de la recepción'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context)
                      .style, // Hereda el estilo por defecto
                  children: [
                    const TextSpan(
                        text: 'Nombre: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: esEnvio
                            ? transferencia.destinatarioNombre
                            : transferencia.remitenteNombre),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    const TextSpan(
                        text: 'Teléfono: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: esEnvio
                            ? transferencia.destinatarioCelular
                            : transferencia.remitenteCelular),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    const TextSpan(
                        text: 'Monto: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '\$${_formatearSaldo(transferencia.monto)}'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    const TextSpan(
                        text: 'Fecha: ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: DateFormat('dd/MM/yyyy HH:mm')
                            .format(transferencia.fechaHora)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
