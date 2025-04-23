import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econoengine/Models/cuota.dart';

class Prestamo {
  final String id;
  final String userId;
  final double monto;
  final String tipoInteres;
  final double tasaInteres;
  final int plazoMeses;
  final Timestamp fechaSolicitud;
  final String estado;
  final List<Cuota> cuotas;
  final double saldoPendiente;
  final double totalPagado;
  final String destinoTelefono;
  final String solicitanteCedula;
  final String solicitanteNombre;

  Prestamo({
    required this.id,
    required this.userId,
    required this.monto,
    required this.tipoInteres,
    required this.tasaInteres,
    required this.plazoMeses,
    required this.fechaSolicitud,
    required this.estado,
    required this.cuotas,
    required this.saldoPendiente,
    required this.totalPagado,
    required this.destinoTelefono,
    required this.solicitanteCedula,
    required this.solicitanteNombre,
  });

  factory Prestamo.fromMap(Map<String, dynamic> data, String id) {
    return Prestamo(
      id: id,
      userId: data['userId'],
      monto: data['monto'].toDouble(),
      tipoInteres: data['tipoInteres'],
      tasaInteres: data['tasaInteres'].toDouble(),
      plazoMeses: data['plazoMeses'],
      fechaSolicitud: data['fechaSolicitud'],
      estado: data['estado'],
      cuotas: (data['cuotas'] as List).map((c) => Cuota.fromMap(c)).toList(),
      saldoPendiente: data['saldoPendiente'].toDouble(),
      totalPagado: data['totalPagado'].toDouble(),
      destinoTelefono: data['destinoTelefono'],
      solicitanteCedula: data['solicitanteCedula'],
      solicitanteNombre: data['solicitanteNombre'],
    );
  }

  factory Prestamo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Prestamo(
      id: doc.id,
      userId: data['userId'],
      monto: (data['monto'] ?? 0).toDouble(),
      tipoInteres: data['tipoInteres'] ?? '',
      tasaInteres: (data['tasaInteres'] ?? 0).toDouble(),
      plazoMeses: data['plazoMeses'] ?? 0,
      fechaSolicitud: data['fechaSolicitud'] ?? Timestamp.now(),
      estado: data['estado'] ?? 'pendiente',
      cuotas:
          (data['cuotas'] as List? ?? []).map((c) => Cuota.fromMap(c)).toList(),
      saldoPendiente: (data['saldoPendiente'] ?? 0).toDouble(),
      totalPagado: (data['totalPagado'] ?? 0).toDouble(),
      destinoTelefono: data['destinoTelefono'] ?? '',
      solicitanteCedula: data['solicitanteCedula'] ?? '',
      solicitanteNombre: data['solicitanteNombre'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'monto': monto,
      'tipoInteres': tipoInteres,
      'tasaInteres': tasaInteres,
      'plazoMeses': plazoMeses,
      'fechaSolicitud': fechaSolicitud,
      'estado': estado,
      'cuotas': cuotas.map((c) => c.toMap()).toList(),
      'saldoPendiente': saldoPendiente,
      'totalPagado': totalPagado,
      'destinoTelefono': destinoTelefono,
      'solicitanteCedula': solicitanteCedula,
      'solicitanteNombre': solicitanteNombre,
    };
  }
}
