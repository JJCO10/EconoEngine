import 'dart:math';

class InflacionService {
  // Calcula la pérdida de valor del dinero debido a la inflación
  Map<String, double> calcularPerdidaValor({
    required double montoInicial,
    required double tasaInflacionAnual,
    required int anos,
  }) {
    final factorPerdida = pow(1 + tasaInflacionAnual, anos);
    final valorFinal = montoInicial / factorPerdida;
    final perdida = montoInicial - valorFinal;
    final poderAdquisitivo = (1 / factorPerdida) * 100;

    return {
      'valorFinal': valorFinal,
      'perdida': perdida,
      'poderAdquisitivo': poderAdquisitivo,
    };
  }

  // Ajusta un precio histórico a valores actuales
  double ajustarPrecioHistorico({
    required double precioOriginal,
    required double tasaInflacionAnual,
    required int anos,
  }) {
    return precioOriginal * pow(1 + tasaInflacionAnual, anos);
  }

  // Calcula el aumento necesario para mantener el poder adquisitivo
  Map<String, double> calcularAumentoPrecio({
    required double precioActual,
    required double tasaInflacionAnual,
    required int anos,
  }) {
    final nuevoPrecio = precioActual * pow(1 + tasaInflacionAnual, anos);
    final aumentoAbsoluto = nuevoPrecio - precioActual;
    final aumentoPorcentual = (pow(1 + tasaInflacionAnual, anos) - 1) * 100;

    return {
      'nuevoPrecio': nuevoPrecio,
      'aumentoAbsoluto': aumentoAbsoluto,
      'aumentoPorcentual': aumentoPorcentual.toDouble(),
    };
  }

  // Simula la inflación acumulada con posibles variaciones anuales
  List<Map<String, dynamic>> simularInflacionAcumulada({
    required double montoInicial,
    required List<double> tasasInflacionAnuales,
  }) {
    double acumulado = montoInicial;
    final resultados = <Map<String, dynamic>>[];

    for (int i = 0; i < tasasInflacionAnuales.length; i++) {
      final tasa = tasasInflacionAnuales[i];
      final valorAnterior = acumulado;
      acumulado *= (1 + tasa);
      final perdidaAnual = valorAnterior - (valorAnterior / (1 + tasa));

      resultados.add({
        'ano': i + 1,
        'tasaInflacion': tasa * 100,
        'valorFinal': acumulado,
        'perdidaAnual': perdidaAnual,
        'poderAdquisitivo': (montoInicial / acumulado) * 100,
      });
    }

    return resultados;
  }

  // Compara diferentes escenarios de inversión vs inflación
  Map<String, dynamic> compararEscenariosInversion({
    required double montoInicial,
    required double tasaInflacionAnual,
    required int anos,
    required double tasaInteresInversion,
    double? aportesAnuales,
  }) {
    final inflacionAcumulada = pow(1 + tasaInflacionAnual, anos);
    final valorSoloInflacion = montoInicial / inflacionAcumulada;

    // Escenario 1: Guardar dinero (sin inversión)
    final valorGuardar = montoInicial;
    final perdidaGuardar = valorGuardar - valorSoloInflacion;
    final poderAdquisitivoGuardar = (valorSoloInflacion / valorGuardar) * 100;

    // Escenario 2: Invertir el dinero
    final factorInversion = pow(1 + tasaInteresInversion, anos);
    final valorInvertido = montoInicial * factorInversion;
    final valorRealInvertido = valorInvertido / inflacionAcumulada;
    final gananciaReal = valorRealInvertido - montoInicial;
    final poderAdquisitivoInversion = (valorRealInvertido / montoInicial) * 100;

    // Escenario 3: Inversión con aportes periódicos
    double valorInversionAportes = montoInicial;
    if (aportesAnuales != null) {
      valorInversionAportes = calcularValorFuturoSerie(
        montoInicial: montoInicial,
        aporteAnual: aportesAnuales,
        tasaInteres: tasaInteresInversion,
        anos: anos,
      );
    }
    final valorRealInversionAportes = valorInversionAportes / inflacionAcumulada;
    final poderAdquisitivoInversionAportes = 
        (valorRealInversionAportes / (montoInicial + (aportesAnuales ?? 0) * anos)) * 100;

    return {
      'inflacionAcumulada': (inflacionAcumulada - 1) * 100,
      'escenarios': {
        'guardarDinero': {
          'valorNominal': valorGuardar,
          'valorReal': valorSoloInflacion,
          'perdida': perdidaGuardar,
          'poderAdquisitivo': poderAdquisitivoGuardar,
        },
        'invertir': {
          'valorNominal': valorInvertido,
          'valorReal': valorRealInvertido,
          'ganancia': gananciaReal,
          'poderAdquisitivo': poderAdquisitivoInversion,
        },
        if (aportesAnuales != null) 
        'inversionAportes': {
          'valorNominal': valorInversionAportes,
          'valorReal': valorRealInversionAportes,
          'poderAdquisitivo': poderAdquisitivoInversionAportes,
        },
      },
    };
  }

  // Método auxiliar para calcular el valor futuro de una serie de pagos
  double calcularValorFuturoSerie({
    required double montoInicial,
    required double aporteAnual,
    required double tasaInteres,
    required int anos,
  }) {
    double valor = montoInicial;
    for (int i = 0; i < anos; i++) {
      valor *= (1 + tasaInteres);
      valor += aporteAnual;
    }
    return valor;
  }
}