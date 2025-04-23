import 'package:cloud_firestore/cloud_firestore.dart';

class Cuota {
  final int numero;
  final Timestamp fechaVencimiento;
  final double monto;
  final double capital;
  final double interes;
  final String estado;

  Cuota({
    required this.numero,
    required this.fechaVencimiento,
    required this.monto,
    required this.capital,
    required this.interes,
    required this.estado,
  });

  factory Cuota.fromMap(Map<String, dynamic> data) {
    return Cuota(
      numero: data['numero'],
      fechaVencimiento: data['fechaVencimiento'],
      monto: data['monto'].toDouble(),
      capital: data['capital'].toDouble(),
      interes: data['interes'].toDouble(),
      estado: data['estado'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numero': numero,
      'fechaVencimiento': fechaVencimiento,
      'monto': monto,
      'capital': capital,
      'interes': interes,
      'estado': estado,
    };
  }

  Cuota copyWith({
    int? numero,
    Timestamp? fechaVencimiento,
    double? monto,
    double? capital,
    double? interes,
    String? estado,
  }) {
    return Cuota(
      numero: numero ?? this.numero,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      monto: monto ?? this.monto,
      capital: capital ?? this.capital,
      interes: interes ?? this.interes,
      estado: estado ?? this.estado,
    );
  }
}
