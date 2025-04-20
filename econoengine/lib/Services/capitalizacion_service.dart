import 'dart:math';

class CapitalizacionService {
  // Sistema de Capitalización Individual
  Map<String, double> calcularIndividual({
    required double aporteMensual,
    required double tasaInteres,
    required int plazoAnos,
    required double comisionAdministrativa,
  }) {
    final meses = plazoAnos * 12;
    final tasaMensual = pow(1 + tasaInteres, 1/12) - 1;
    double saldo = 0;
    double totalAportes = 0;
    double totalIntereses = 0;
    double totalComisiones = 0;

    for (int mes = 1; mes <= meses; mes++) {
      final aporteNeto = aporteMensual * (1 - comisionAdministrativa);
      final interes = (saldo + aporteNeto) * tasaMensual;
      
      totalAportes += aporteMensual;
      totalIntereses += interes;
      totalComisiones += aporteMensual * comisionAdministrativa;
      saldo += aporteNeto + interes;
    }

    return {
      'saldoFinal': saldo,
      'totalAportes': totalAportes,
      'totalIntereses': totalIntereses,
      'totalComisiones': totalComisiones,
    };
  }

  // Sistema de Capitalización Colectiva
  Map<String, dynamic> calcularColectiva({
    required List<double> aportes,
    required double tasaInteres,
    required int plazoAnos,
    required double comisionAdministrativa,
    required int participantes,
  }) {
    final meses = plazoAnos * 12;
    final tasaMensual = pow(1 + tasaInteres, 1/12) - 1;
    double saldoTotal = 0;
    double totalAportes = 0;
    double totalIntereses = 0;
    double totalComisiones = 0;
    
    final saldosIndividuales = List<double>.filled(participantes, 0);
    final aportesIndividuales = List<double>.from(aportes);

    // Asegurar que la lista de aportes coincida con el número de participantes
    if (aportesIndividuales.length < participantes) {
      aportesIndividuales.addAll(List<double>.filled(participantes - aportes.length, aportes.last));
    } else if (aportesIndividuales.length > participantes) {
      aportesIndividuales.removeRange(participantes, aportes.length);
    }

    for (int mes = 1; mes <= meses; mes++) {
      double aporteTotal = 0;
      
      for (int i = 0; i < participantes; i++) {
        final aporteNeto = aportesIndividuales[i] * (1 - comisionAdministrativa);
        saldosIndividuales[i] += aporteNeto;
        aporteTotal += aportesIndividuales[i];
        totalComisiones += aportesIndividuales[i] * comisionAdministrativa;
      }

      final interesTotal = saldoTotal * tasaMensual;
      final factorDistribucion = interesTotal / saldoTotal;

      for (int i = 0; i < participantes; i++) {
        final interesIndividual = saldosIndividuales[i] * factorDistribucion;
        saldosIndividuales[i] += interesIndividual;
        totalIntereses += interesIndividual;
      }

      totalAportes += aporteTotal;
      saldoTotal = saldosIndividuales.reduce((a, b) => a + b);
    }

    return {
      'saldoTotal': saldoTotal,
      'saldosIndividuales': saldosIndividuales,
      'totalAportes': totalAportes,
      'totalIntereses': totalIntereses,
      'totalComisiones': totalComisiones,
    };
  }

  // Sistema de Capitalización y Reparto (Mixto)
  Map<String, dynamic> calcularMixto({
    required double aporteMensual,
    required double tasaInteresCapitalizacion,
    required double tasaInteresReparto,
    required int plazoAnos,
    required double porcentajeCapitalizacion, // 0-1 (ej: 0.7 para 70%)
  }) {
    final meses = plazoAnos * 12;
    final tasaMensualCap = pow(1 + tasaInteresCapitalizacion, 1/12) - 1;
    final tasaMensualRep = pow(1 + tasaInteresReparto, 1/12) - 1;
    
    double saldoCapitalizacion = 0;
    double saldoReparto = 0;
    double totalAportes = 0;
    double totalInteresesCap = 0;
    double totalInteresesRep = 0;

    for (int mes = 1; mes <= meses; mes++) {
      final aporteCap = aporteMensual * porcentajeCapitalizacion;
      final aporteRep = aporteMensual * (1 - porcentajeCapitalizacion);
      
      // Parte de capitalización
      final interesCap = saldoCapitalizacion * tasaMensualCap;
      saldoCapitalizacion += aporteCap + interesCap;
      totalInteresesCap += interesCap;
      
      // Parte de reparto
      final interesRep = saldoReparto * tasaMensualRep;
      saldoReparto += aporteRep + interesRep;
      totalInteresesRep += interesRep;
      
      totalAportes += aporteMensual;
    }

    return {
      'saldoCapitalizacion': saldoCapitalizacion,
      'saldoReparto': saldoReparto,
      'saldoTotal': saldoCapitalizacion + saldoReparto,
      'totalAportes': totalAportes,
      'totalInteresesCap': totalInteresesCap,
      'totalInteresesRep': totalInteresesRep,
    };
  }

  // Sistema de Capitalización en Seguros
  Map<String, dynamic> calcularSeguros({
    required double prima,
    required double tasaInteres,
    required int plazoAnos,
    required double comisionAdministrativa,
    required double costoSeguro,
    required int frecuenciaPago, // 1=anual, 12=meses
  }) {
    final periodos = plazoAnos * (12 ~/ frecuenciaPago);
    final tasaPeriodica = pow(1 + tasaInteres, frecuenciaPago/12) - 1;
    
    double saldo = 0;
    double totalPrimas = 0;
    double totalIntereses = 0;
    double totalComisiones = 0;
    double totalSeguro = 0;

    for (int periodo = 1; periodo <= periodos; periodo++) {
      final primaNeta = prima * (1 - comisionAdministrativa);
      final interes = saldo * tasaPeriodica;
      
      totalPrimas += prima;
      totalIntereses += interes;
      totalComisiones += prima * comisionAdministrativa;
      totalSeguro += costoSeguro;
      
      saldo += primaNeta + interes - costoSeguro;
    }

    return {
      'saldoFinal': saldo,
      'totalPrimas': totalPrimas,
      'totalIntereses': totalIntereses,
      'totalComisiones': totalComisiones,
      'totalSeguro': totalSeguro,
    };
  }
}