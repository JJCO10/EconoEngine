import 'dart:math';

class GradienteService {
  Map<String, double> calcularAritmetico(
    double primerPago, double gradiente, double tasaInteres, int periodos) {
    final i = tasaInteres / 100;
    final results = <String, double>{};

    final factor1 = (1 - (1 / pow(1 + i, periodos))) / i;
    final factor2 = (1 - (1 + periodos * i) / pow(1 + i, periodos)) / i;
    results['valorPresente'] = primerPago * factor1 + gradiente * factor2;

    final factor3 = (pow(1 + i, periodos) - 1) / i;
    final factor4 = ((pow(1 + i, periodos) - 1) / (i * i)) - (periodos / i);
    results['valorFuturo'] = primerPago * factor3 + gradiente * factor4;

    results['serie'] = primerPago + (gradiente * (periodos - 1));

    return results;
  }

  Map<String, double> calcularGeometrico(
    double primerPago, double tasaCrecimiento, double tasaInteres, int periodos) {
    final i = tasaInteres / 100;
    final g = tasaCrecimiento / 100;
    final results = <String, double>{};

    if (i != g) {
      results['valorPresente'] = primerPago * ((1 - pow((1 + g) / (1 + i), periodos))) / (i - g);
    } else {
      results['valorPresente'] = primerPago * (periodos / (1 + i));
    }

    results['valorFuturo'] = primerPago * ((pow(1 + i, periodos) - pow(1 + g, periodos))) / (i - g);
    results['serie'] = primerPago * pow(1 + g, periodos - 1);

    return results;
  }
}