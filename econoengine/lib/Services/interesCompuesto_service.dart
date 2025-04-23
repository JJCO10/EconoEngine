import 'dart:math';
import 'package:econoengine/l10n/app_localizations_setup.dart';
import 'package:flutter/material.dart';

class InteresCompuestoService {
  // Cálculo del Monto Compuesto (MC = C * (1 + i)^n)
  double calcularMontoCompuesto(
    double capital,
    double tasa,
    double tiempo, {
    required String unidadTiempo,
    required String unidadTasa,
  }) {
    final tConvertido = _convertirTiempo(tiempo, unidadTiempo);
    final iConvertida = _convertirTasa(tasa, unidadTasa);
    return capital * pow(1 + (iConvertida / 100), tConvertido);
  }

  // Cálculo del Tiempo (n = log(MC/C) / log(1+i))
  double calcularTiempo(
    double capital,
    double montoCompuesto,
    double tasa, {
    String unidadTiempo = 'years',
    String unidadTasa = 'annual',
  }) {
    final iConvertida = _convertirTasa(tasa, unidadTasa);
    final tiempoEnAnios =
        (log(montoCompuesto) - log(capital)) / log(1 + (iConvertida / 100));
    return _convertirTiempoInverso(tiempoEnAnios, unidadTiempo);
  }

  // Cálculo de la Tasa de Interés (i = (MC/C)^(1/n) - 1)
  double calcularTasaInteres(
    double capital,
    double montoCompuesto,
    double tiempo, {
    String unidadTiempo = 'years',
    String unidadTasa = 'annual',
  }) {
    final tConvertido = _convertirTiempo(tiempo, unidadTiempo);
    final tasaAnual =
        ((pow(montoCompuesto / capital, 1 / tConvertido) as double) - 1) * 100;
    return _convertirTasaInversa(tasaAnual, unidadTasa);
  }

  // --- Conversiones para el tiempo ---
  double _convertirTiempo(double t, String unidadTiempo) {
    switch (unidadTiempo) {
      case 'days':
        return t / 365;
      case 'months':
        return t / 12;
      case 'quarters':
        return t / 4;
      case 'semesters':
        return t / 2;
      default: // years
        return t;
    }
  }

  double _convertirTiempoInverso(double tAnios, String unidadTiempo) {
    switch (unidadTiempo) {
      case 'days':
        return tAnios * 365;
      case 'months':
        return tAnios * 12;
      case 'quarters':
        return tAnios * 4;
      case 'semesters':
        return tAnios * 2;
      default: // years
        return tAnios;
    }
  }

  // --- Conversiones para la tasa ---
  double _convertirTasa(double tasa, String unidadTasa) {
    switch (unidadTasa) {
      case 'monthly':
        return tasa * 12;
      case 'quarterly':
        return tasa * 4;
      case 'semiannual':
        return tasa * 2;
      case 'daily':
        return tasa * 365;
      default: // annual
        return tasa;
    }
  }

  double _convertirTasaInversa(double tasaAnual, String unidadTasa) {
    switch (unidadTasa) {
      case 'monthly':
        return tasaAnual / 12;
      case 'quarterly':
        return tasaAnual / 4;
      case 'semiannual':
        return tasaAnual / 2;
      case 'daily':
        return tasaAnual / 365;
      default: // annual
        return tasaAnual;
    }
  }

  // Validación de campos
  String validarCampos({
    required double? capital,
    required double? montoCompuesto,
    required double? tasa,
    required double? tiempo,
    required List<bool> requeridos,
  }) {
    if (requeridos[0] && (capital == null || capital <= 0)) {
      return 'invalidCapital'; // Clave de localización
    }
    if (requeridos[1] && (montoCompuesto == null || montoCompuesto <= 0)) {
      return 'invalidAmount'; // Clave de localización
    }
    if (requeridos[2] && (tasa == null || tasa <= 0))
      return 'invalidRate'; // Clave de localización
    if (requeridos[3] && (tiempo == null || tiempo <= 0)) {
      return 'invalidTime'; // Clave de localización
    }
    return '';
  }
}
