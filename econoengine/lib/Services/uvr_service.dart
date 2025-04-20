import 'dart:math';

class UvrService {
  // Método para calcular la variación del valor de la UVR entre dos fechas
  double calcularVariacionUvr(double valorInicial, double valorFinal, DateTime fechaInicial, DateTime fechaFinal) {
    if (valorInicial <= 0 || valorFinal <= 0) {
      throw ArgumentError('Los valores de UVR deben ser mayores que cero');
    }
    
    // Calcular días entre las fechas
    int diasEntreFechas = fechaFinal.difference(fechaInicial).inDays;
    if (diasEntreFechas <= 0) {
      throw ArgumentError('La fecha final debe ser posterior a la fecha inicial');
    }
    
    // Calcular variación porcentual
    double variacion = (valorFinal - valorInicial) / valorInicial;
    
    // Convertir a tasa efectiva anual
    double tasaEfectivaAnual = pow(1 + variacion, 365 / diasEntreFechas) - 1;
    
    return tasaEfectivaAnual;
  }

  // Método para convertir un valor en pesos a UVR
  double convertirPesosAUvr(double valorPesos, double valorUvr) {
    if (valorUvr <= 0) {
      throw ArgumentError('El valor de la UVR debe ser mayor que cero');
    }
    return valorPesos / valorUvr;
  }

  // Método para convertir un valor en UVR a pesos
  double convertirUvrAPesos(double valorUvr, double valorActualUvr) {
    if (valorActualUvr <= 0) {
      throw ArgumentError('El valor actual de la UVR debe ser mayor que cero');
    }
    return valorUvr * valorActualUvr;
  }

  // Método para calcular la cuota de un crédito en UVR
  double calcularCuotaCreditoUvr(double montoUvr, double tasaInteresEA, int plazoMeses) {
    if (montoUvr <= 0) {
      throw ArgumentError('El monto del crédito debe ser mayor que cero');
    }
    if (plazoMeses <= 0) {
      throw ArgumentError('El plazo debe ser mayor que cero');
    }
    
    // Convertir tasa efectiva anual a tasa efectiva mensual
    double tasaMensual = pow(1 + tasaInteresEA, 1/12) - 1;
    
    // Calcular factor de amortización
    double factor = tasaMensual * pow(1 + tasaMensual, plazoMeses) / (pow(1 + tasaMensual, plazoMeses) - 1);
    
    // Calcular cuota en UVR
    return montoUvr * factor;
  }

  // Método para proyectar el valor futuro de la UVR
  double proyectarUvr(double valorActualUvr, double inflacionAnualProyectada, int numeroDias) {
    if (valorActualUvr <= 0) {
      throw ArgumentError('El valor actual de la UVR debe ser mayor que cero');
    }
    if (numeroDias < 0) {
      throw ArgumentError('El número de días debe ser positivo');
    }
    
    // Convertir inflación anual a inflación diaria
    double inflacionDiaria = pow(1 + inflacionAnualProyectada, 1/365) - 1;
    
    // Proyectar valor futuro
    return valorActualUvr * pow(1 + inflacionDiaria, numeroDias);
  }

  // Método para generar tabla de amortización de un crédito en UVR
  List<Map<String, dynamic>> generarTablaAmortizacionUvr(
      double montoPrestamoUvr, 
      double valorInicialUvr, 
      double tasaInteresEA, 
      int plazoMeses, 
      double inflacionAnualProyectada) {
    
    if (montoPrestamoUvr <= 0 || valorInicialUvr <= 0 || plazoMeses <= 0) {
      throw ArgumentError('Los valores de monto, UVR y plazo deben ser mayores que cero');
    }
    
    List<Map<String, dynamic>> tabla = [];
    
    // Convertir tasa efectiva anual a tasa efectiva mensual
    double tasaMensual = pow(1 + tasaInteresEA, 1/12) - 1;
    
    // Calcular cuota fija en UVR
    double cuotaUvr = calcularCuotaCreditoUvr(montoPrestamoUvr, tasaInteresEA, plazoMeses);
    
    // Convertir inflación anual a inflación mensual
    double inflacionMensual = pow(1 + inflacionAnualProyectada, 1/12) - 1;
    
    double saldoUvr = montoPrestamoUvr;
    double valorUvr = valorInicialUvr;
    
    for (int mes = 1; mes <= plazoMeses; mes++) {
      // Calcular interés del mes
      double interesUvr = saldoUvr * tasaMensual;
      
      // Calcular abono a capital
      double abonoCapitalUvr = cuotaUvr - interesUvr;
      
      // Actualizar saldo
      double nuevoSaldoUvr = saldoUvr - abonoCapitalUvr;
      
      // Actualizar valor de la UVR para el siguiente mes
      valorUvr = valorUvr * (1 + inflacionMensual);
      
      // Convertir valores de UVR a pesos
      double cuotaPesos = cuotaUvr * valorUvr;
      double interesPesos = interesUvr * valorUvr;
      double abonoCapitalPesos = abonoCapitalUvr * valorUvr;
      double saldoPesos = nuevoSaldoUvr * valorUvr;
      
      // Añadir registro a la tabla
      tabla.add({
        'mes': mes,
        'cuotaUvr': cuotaUvr,
        'interesUvr': interesUvr,
        'abonoCapitalUvr': abonoCapitalUvr,
        'saldoUvr': nuevoSaldoUvr,
        'valorUvr': valorUvr,
        'cuotaPesos': cuotaPesos,
        'interesPesos': interesPesos,
        'abonoCapitalPesos': abonoCapitalPesos,
        'saldoPesos': saldoPesos,
      });
      
      // Actualizar saldo para el siguiente mes
      saldoUvr = nuevoSaldoUvr;
      
      // Si el saldo llega a cero o menos, terminar
      if (saldoUvr <= 0) break;
    }
    
    return tabla;
  }
}