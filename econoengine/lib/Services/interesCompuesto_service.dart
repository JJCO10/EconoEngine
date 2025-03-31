import 'dart:math';

class InteresCompuestoService {
  // Cálculo del Monto Compuesto (MC = C * (1 + i)^n)
  double calcularMontoCompuesto(double capital, double tasa, double tiempo) {
    return capital * pow(1 + (tasa / 100), tiempo);
  }

  // Cálculo del Tiempo (n = log(MC/C) / log(1+i))
  double calcularTiempo(double capital, double montoCompuesto, double tasa) {
    return (log(montoCompuesto) - log(capital)) / log(1 + (tasa / 100));
  }

  // Cálculo de la Tasa de Interés (i = (MC/C)^(1/n) - 1)
  double calcularTasaInteres(double capital, double montoCompuesto, double tiempo) {
    return (pow(montoCompuesto / capital, 1 / tiempo) - 1) * 100;
  }

  // Validación de campos
  String validarCampos({
    required double? capital,
    required double? montoCompuesto,
    required double? tasa,
    required double? tiempo,
    required List<bool> requeridos,
  }) {
    if (requeridos[0] && (capital == null || capital <= 0)) return 'Capital inválido';
    if (requeridos[1] && (montoCompuesto == null || montoCompuesto <= 0)) return 'Monto inválido';
    if (requeridos[2] && (tasa == null || tasa <= 0)) return 'Tasa inválida';
    if (requeridos[3] && (tiempo == null || tiempo <= 0)) return 'Tiempo inválido';
    return '';
  }
}