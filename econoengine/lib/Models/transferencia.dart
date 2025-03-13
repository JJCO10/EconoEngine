import 'package:cloud_firestore/cloud_firestore.dart';

class Transferencia {
  final String remitenteNombre;
  final String remitenteCelular;
  final String remitenteCedula;
  final String destinatarioNombre;
  final String destinatarioCelular;
  final String destinatarioCedula;
  final double monto;
  final DateTime fechaHora;
  final String userId; // Identificador del usuario que realiza la transferencia

  Transferencia({
    required this.remitenteNombre,
    required this.remitenteCelular,
    required this.remitenteCedula,
    required this.destinatarioNombre,
    required this.destinatarioCelular,
    required this.destinatarioCedula,
    required this.monto,
    required this.fechaHora,
    required this.userId,
  });

  // Convertir el modelo a un Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'remitenteNombre': remitenteNombre,
      'remitenteCelular': remitenteCelular,
      'remitenteCedula': remitenteCedula,
      'destinatarioNombre': destinatarioNombre,
      'destinatarioCelular': destinatarioCelular,
      'destinatarioCedula': destinatarioCedula,
      'monto': monto,
      'fechaHora': fechaHora,
      'userId': userId,
    };
  }

  // Crear un modelo Transferencia desde un Map de Firestore
  factory Transferencia.fromMap(Map<String, dynamic> data) {
    return Transferencia(
      remitenteNombre: data['remitenteNombre'],
      remitenteCelular: data['remitenteCelular'],
      remitenteCedula: data['remitenteCedula'],
      destinatarioNombre: data['destinatarioNombre'],
      destinatarioCelular: data['destinatarioCelular'],
      destinatarioCedula: data['destinatarioCedula'],
      monto: data['monto'],
      fechaHora: (data['fechaHora'] as Timestamp).toDate(),
      userId: data['userId'],
    );
  }
}