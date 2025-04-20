import 'dart:math';

class AmortizacionService {
  // Método para calcular la amortización alemana
  List<Map<String, dynamic>> calcularAleman(
    double monto, 
    double tasa, 
    int periodos, {
    String unidadTasa = 'anual',
    String unidadPeriodo = 'meses',
  }) {
    List<Map<String, dynamic>> tabla = [];
    double capitalConstante = monto / periodos;
    double saldo = monto;
    double tasaPeriodica = _convertirTasa(tasa, unidadTasa, periodos, unidadPeriodo);

    for (int i = 1; i <= periodos; i++) {
      double interes = saldo * tasaPeriodica;
      double cuota = capitalConstante + interes;
      saldo -= capitalConstante;

      tabla.add({
        'Periodo': i,
        'Cuota': cuota.toStringAsFixed(2),
        'Interés': interes.toStringAsFixed(2),
        'Capital': capitalConstante.toStringAsFixed(2),
        'Saldo': saldo.toStringAsFixed(2),
      });
    }

    return tabla;
  }

  // Método para calcular la amortización francesa
  List<Map<String, dynamic>> calcularFrances(
    double monto, 
    double tasa, 
    int periodos, {
    String unidadTasa = 'anual',
    String unidadPeriodo = 'meses',
  }) {
    List<Map<String, dynamic>> tabla = [];
    double tasaPeriodica = _convertirTasa(tasa, unidadTasa, periodos, unidadPeriodo);
    double cuota = monto * (tasaPeriodica * pow(1 + tasaPeriodica, periodos)) / 
                  (pow(1 + tasaPeriodica, periodos) - 1);
    double saldo = monto;

    for (int i = 1; i <= periodos; i++) {
      double interes = saldo * tasaPeriodica;
      double capital = cuota - interes;
      saldo -= capital;

      tabla.add({
        'Periodo': i,
        'Cuota': cuota.toStringAsFixed(2),
        'Interés': interes.toStringAsFixed(2),
        'Capital': capital.toStringAsFixed(2),
        'Saldo': saldo.toStringAsFixed(2),
      });
    }

    return tabla;
  }

  // Método para calcular la amortización americana
  List<Map<String, dynamic>> calcularAmericano(
    double monto, 
    double tasa, 
    int periodos, {
    String unidadTasa = 'anual',
    String unidadPeriodo = 'meses',
  }) {
    List<Map<String, dynamic>> tabla = [];
    double tasaPeriodica = _convertirTasa(tasa, unidadTasa, periodos, unidadPeriodo);
    double interesPeriodico = monto * tasaPeriodica;

    for (int i = 1; i <= periodos; i++) {
      double cuota = (i == periodos) ? monto + interesPeriodico : interesPeriodico;
      double capital = (i == periodos) ? monto : 0;
      double saldo = (i == periodos) ? 0 : monto;

      tabla.add({
        'Periodo': i,
        'Cuota': cuota.toStringAsFixed(2),
        'Interés': interesPeriodico.toStringAsFixed(2),
        'Capital': capital.toStringAsFixed(2),
        'Saldo': saldo.toStringAsFixed(2),
      });
    }

    return tabla;
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