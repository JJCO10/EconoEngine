import 'dart:math';

class UvrService {
  // Método para calcular la variación del valor de la UVR entre dos fechas
  // (Este es el único que debe devolver un porcentaje)
  double calcularVariacionUvr(double valorInicial, double valorFinal,
      DateTime fechaInicial, DateTime fechaFinal) {
    if (valorInicial <= 0 || valorFinal <= 0) {
      throw ArgumentError('Los valores de UVR deben ser mayores que cero');
    }

    int diasEntreFechas = fechaFinal.difference(fechaInicial).inDays;
    if (diasEntreFechas <= 0) {
      throw ArgumentError(
          'La fecha final debe ser posterior a la fecha inicial');
    }

    double variacion = (valorFinal - valorInicial) / valorInicial;
    double tasaEfectivaAnual = pow(1 + variacion, 365 / diasEntreFechas) - 1;

    return tasaEfectivaAnual;
  }

  // Método para convertir un valor en pesos a UVR - Devuelve valor absoluto
  double convertirPesosAUvr(double valorPesos, double valorUvr) {
    if (valorUvr <= 0) {
      throw ArgumentError('El valor de la UVR debe ser mayor que cero');
    }
    return valorPesos / valorUvr;
  }

  // Método para convertir un valor en UVR a pesos - Devuelve valor absoluto
  double convertirUvrAPesos(double valorUvr, double valorActualUvr) {
    if (valorActualUvr <= 0) {
      throw ArgumentError('El valor actual de la UVR debe ser mayor que cero');
    }
    return valorUvr * valorActualUvr;
  }

  // Método para calcular la cuota de un crédito en UVR - Devuelve valor absoluto
  double calcularCuotaCreditoUvr(
      double montoUvr, double tasaInteresEA, int plazoMeses) {
    if (montoUvr <= 0) {
      throw ArgumentError('El monto del crédito debe ser mayor que cero');
    }
    if (plazoMeses <= 0) {
      throw ArgumentError('El plazo debe ser mayor que cero');
    }

    double tasaMensual = pow(1 + tasaInteresEA, 1 / 12) - 1;
    double factor = tasaMensual *
        pow(1 + tasaMensual, plazoMeses) /
        (pow(1 + tasaMensual, plazoMeses) - 1);

    return montoUvr * factor;
  }

  // Método para proyectar el valor futuro de la UVR - Devuelve valor absoluto
  double proyectarUvr(
      double valorActualUvr, double inflacionAnualProyectada, int numeroDias) {
    if (valorActualUvr <= 0) {
      throw ArgumentError('El valor actual de la UVR debe ser mayor que cero');
    }
    if (numeroDias < 0) {
      throw ArgumentError('El número de días debe ser positivo');
    }

    double inflacionDiaria = pow(1 + inflacionAnualProyectada, 1 / 365) - 1;
    return valorActualUvr * pow(1 + inflacionDiaria, numeroDias);
  }

  // Método para generar tabla de amortización de un crédito en UVR
  // En UvrService
  List<Map<String, dynamic>> generarTablaAmortizacionUvr(
      double montoPrestamoUvr,
      double valorInicialUvr,
      double tasaInteresEA,
      int plazoMeses,
      double inflacionAnualProyectada) {
    List<Map<String, dynamic>> tabla = [];
    double tasaMensual = pow(1 + tasaInteresEA, 1 / 12) - 1;
    double cuotaUvr =
        calcularCuotaCreditoUvr(montoPrestamoUvr, tasaInteresEA, plazoMeses);
    double inflacionMensual = pow(1 + inflacionAnualProyectada, 1 / 12) - 1;

    double saldoUvr = montoPrestamoUvr;
    double valorUvr = valorInicialUvr;

    for (int mes = 1; mes <= plazoMeses; mes++) {
      double interesUvr = saldoUvr * tasaMensual;
      double abonoCapitalUvr = cuotaUvr - interesUvr;
      double nuevoSaldoUvr = saldoUvr - abonoCapitalUvr;

      valorUvr = valorUvr * (1 + inflacionMensual);

      // Formateamos los números para mejor visualización
      tabla.add({
        'Mes': mes,
        'Valor UVR': valorUvr.toStringAsFixed(4),
        'Cuota UVR': cuotaUvr.toStringAsFixed(4),
        'Interés UVR': interesUvr.toStringAsFixed(4),
        'Abono Capital UVR': abonoCapitalUvr.toStringAsFixed(4),
        'Saldo UVR': nuevoSaldoUvr.toStringAsFixed(4),
        'Cuota Pesos': (cuotaUvr * valorUvr).toStringAsFixed(2),
        'Interés Pesos': (interesUvr * valorUvr).toStringAsFixed(2),
        'Abono Capital Pesos': (abonoCapitalUvr * valorUvr).toStringAsFixed(2),
        'Saldo Pesos': (nuevoSaldoUvr * valorUvr).toStringAsFixed(2),
      });

      saldoUvr = nuevoSaldoUvr;
      if (saldoUvr <= 0) break;
    }

    return tabla;
  }
}
