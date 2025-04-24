import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econoengine/Controllers/auth_controller.dart';
import 'package:econoengine/Models/prestamo.dart';
import 'package:econoengine/Models/cuota.dart';

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
    required String estado,
    String? tipoGradiente, // Parámetros opcionales para los tipos especiales
    String? tipoAmortizacion,
    double? valorGradiente,
  }) async {
    try {
      // Calcular las cuotas según el tipo de interés
      List<Map<String, dynamic>> cuotasData = [];

      // Aquí calculamos las cuotas según corresponda
      final AuthController authController =
          AuthController(); // Considera usar una única instancia
      List<Cuota> cuotas = authController.calcularCuotasPrestamo(
        monto: monto,
        tasaAnual: tasaInteres,
        plazoMeses: plazoMeses,
        tipoInteres: tipoInteres,
        tipoGradiente: tipoGradiente ?? 'aritmético', // Valores por defecto
        tipoAmortizacion: tipoAmortizacion ?? 'francés',
        valorGradiente: valorGradiente ?? 10.0,
      );

      // Convertir las cuotas a mapas para guardar en Firestore
      for (var cuota in cuotas) {
        cuotasData.add({
          'numero': cuota.numero,
          'monto': cuota.monto,
          'capital': cuota.capital,
          'interes': cuota.interes,
          'fechaVencimiento': cuota.fechaVencimiento,
          'estado': cuota.estado,
        });
      }

      // Calcular el total del préstamo
      double totalPrestamo =
          cuotas.fold(0, (prev, cuota) => prev + cuota.monto);

      // Guardar en Firestore
      await FirebaseFirestore.instance.collection('prestamos').add({
        'userId': userId,
        'monto': monto,
        'tipoInteres': tipoInteres,
        'tasaInteres': tasaInteres,
        'plazoMeses': plazoMeses,
        'destinoTelefono': destinoTelefono,
        'solicitanteCedula': solicitanteCedula,
        'solicitanteNombre': solicitanteNombre,
        'estado': estado,
        'fechaSolicitud': DateTime.now(),
        'cuotas': cuotasData,
        'saldoPendiente': totalPrestamo,
        'totalPagado': 0,
        // Añadir los campos adicionales si están presentes
        if (tipoInteres == 'gradiente') 'tipoGradiente': tipoGradiente,
        if (tipoInteres == 'gradiente') 'valorGradiente': valorGradiente,
        if (tipoInteres == 'amortizacion') 'tipoAmortizacion': tipoAmortizacion,
      });

      print('LoanService - Préstamo guardado correctamente');
    } catch (e) {
      print('LoanService - Error al guardar préstamo: $e');
      rethrow;
    }
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
