import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econoengine/Models/prestamo.dart';
import 'package:econoengine/Models/cuota.dart';
import 'package:intl/intl.dart';

class LoanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Prestamo>> obtenerPrestamosUsuario(String userId) async {
    final query = await _firestore
        .collection('prestamos')
        .where('userId', isEqualTo: userId)
        .orderBy('fechaSolicitud', descending: true)
        .get();

    return query.docs
        .map((doc) => Prestamo.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> solicitarPrestamo({
    required String userId,
    required double monto,
    required String tipoInteres,
    required double tasaInteres,
    required int plazoMeses,
    required String destinoTelefono,
    required String solicitanteCedula,
    required String solicitanteNombre,
  }) async {
    final cuotasCalculadas = calcularCuotas(
      monto: monto,
      tasaAnual: tasaInteres,
      plazoMeses: plazoMeses,
      tipoInteres: tipoInteres,
    );

    await _firestore.collection('prestamos').add({
      'userId': userId,
      'monto': monto,
      'tipoInteres': tipoInteres,
      'tasaInteres': tasaInteres,
      'plazoMeses': plazoMeses,
      'fechaSolicitud': Timestamp.now(),
      'estado': 'pendiente',
      'telefonoDestino': destinoTelefono,
      'solicitanteCedula': solicitanteCedula,
      'solicitanteNombre': solicitanteNombre,
      'cuotas': cuotasCalculadas.map((cuota) => cuota.toMap()).toList(),
      'saldoPendiente':
          monto, // Inicialmente el saldo pendiente es el monto total
      'totalPagado': 0.0, // Inicialmente no se ha pagado nada
    });
  }

  Future<List<Prestamo>> obtenerPrestamosPendientes() async {
    final query = await _firestore
        .collection('prestamos')
        .where('estado', isEqualTo: 'pendiente')
        .orderBy('fechaSolicitud')
        .get();

    return query.docs
        .map((doc) => Prestamo.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> aprobarPrestamo(String prestamoId, String adminId) async {
    await _firestore.collection('prestamos').doc(prestamoId).update({
      'estado': 'aprobado',
      'fechaAprobacion': Timestamp.now(),
      'aprobadoPor': adminId,
    });
  }

  Future<void> rechazarPrestamo(String prestamoId, String adminId) async {
    await _firestore.collection('prestamos').doc(prestamoId).update({
      'estado': 'rechazado',
      'fechaRechazo': Timestamp.now(),
      'rechazadoPor': adminId,
    });
  }

  Future<void> pagarCuota(String prestamoId, int numeroCuota) async {
    await _firestore.runTransaction((transaction) async {
      final prestamoDoc = await transaction.get(
        _firestore.collection('prestamos').doc(prestamoId),
      );

      if (!prestamoDoc.exists) throw Exception('Préstamo no encontrado');

      final prestamo = Prestamo.fromMap(prestamoDoc.data()!, prestamoDoc.id);
      final cuota = prestamo.cuotas.firstWhere((c) => c.numero == numeroCuota);

      // Actualizar la cuota
      final nuevasCuotas = prestamo.cuotas.map((c) {
        if (c.numero == numeroCuota) {
          return c.copyWith(estado: 'pagada');
        }
        return c;
      }).toList();

      // Calcular nuevo saldo
      final nuevoSaldo = prestamo.saldoPendiente - cuota.monto;
      final nuevoTotalPagado = prestamo.totalPagado + cuota.monto;

      // Actualizar préstamo
      transaction.update(prestamoDoc.reference, {
        'cuotas': nuevasCuotas.map((c) => c.toMap()).toList(),
        'saldoPendiente': nuevoSaldo,
        'totalPagado': nuevoTotalPagado,
        'estado': nuevoSaldo <= 0 ? 'pagado' : prestamo.estado,
      });
    });
  }

  List<Cuota> calcularCuotas({
    required double monto,
    required double tasaAnual,
    required int plazoMeses,
    required String tipoInteres,
  }) {
    final tasaMensual = tasaAnual / 12 / 100;
    final cuotas = <Cuota>[];
    final fechaActual = DateTime.now();

    if (tipoInteres == 'compuesto') {
      // Cálculo tipo francés (cuota fija)
      final cuotaMonto = monto *
          tasaMensual *
          pow(1 + tasaMensual, plazoMeses) /
          (pow(1 + tasaMensual, plazoMeses) - 1);

      double saldo = monto;
      for (var i = 1; i <= plazoMeses; i++) {
        final interes = saldo * tasaMensual;
        final capital = cuotaMonto - interes;
        saldo -= capital;

        cuotas.add(Cuota(
          numero: i,
          fechaVencimiento: Timestamp.fromDate(
            DateTime(fechaActual.year, fechaActual.month + i, fechaActual.day),
          ),
          monto: cuotaMonto,
          capital: capital,
          interes: interes,
          estado: 'pendiente',
        ));
      }
    } else if (tipoInteres == 'simple') {
      // Cálculo de interés simple
      final interesTotal = monto * tasaMensual * plazoMeses;
      final cuotaMonto = (monto + interesTotal) / plazoMeses;

      for (var i = 1; i <= plazoMeses; i++) {
        cuotas.add(Cuota(
          numero: i,
          fechaVencimiento: Timestamp.fromDate(
            DateTime(fechaActual.year, fechaActual.month + i, fechaActual.day),
          ),
          monto: cuotaMonto,
          capital: monto / plazoMeses,
          interes: interesTotal / plazoMeses,
          estado: 'pendiente',
        ));
      }
    }
    // Agregar más tipos de interés aquí...

    return cuotas;
  }
}
