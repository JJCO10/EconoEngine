import 'dart:math';

class GradienteService {
  Map<String, double> calcularAritmetico(
    double primerPago, 
    double gradiente, 
    double tasaInteres, 
    int periodos, {
    String unidadTasa = 'anual',
    String unidadPeriodo = 'meses',
  }) {
    final i = _convertirTasa(tasaInteres, unidadTasa, periodos, unidadPeriodo);
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
    double primerPago, 
    double tasaCrecimiento, 
    double tasaInteres, 
    int periodos, {
    String unidadTasa = 'anual',
    String unidadPeriodo = 'meses',
  }) {
    final i = _convertirTasa(tasaInteres, unidadTasa, periodos, unidadPeriodo);
    final g = _convertirTasa(tasaCrecimiento, unidadTasa, periodos, unidadPeriodo);
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

  // Conversión de tasas según unidad
  double _convertirTasa(double tasa, String unidadTasa, int periodos, String unidadPeriodo) {
    // Primero convertir a tasa anual si no lo está
    double tasaAnual;
    switch (unidadTasa) {
      case 'mensual':
        tasaAnual = tasa * 12;
        break;
      case 'trimestral':
        tasaAnual = tasa * 4;
        break;
      case 'semestral':
        tasaAnual = tasa * 2;
        break;
      case 'diaria':
        tasaAnual = tasa * 365;
        break;
      default: // anual
        tasaAnual = tasa;
    }

    // Luego convertir a tasa periódica según los periodos
    switch (unidadPeriodo) {
      case 'meses':
        return tasaAnual / 100 / 12;
      case 'trimestres':
        return tasaAnual / 100 / 4;
      case 'semestres':
        return tasaAnual / 100 / 2;
      case 'días':
        return tasaAnual / 100 / 365;
      default: // años
        return tasaAnual / 100;
    }
  }
}