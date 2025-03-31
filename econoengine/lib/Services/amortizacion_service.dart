import 'dart:math';

class AmortizacionService {
  // Método para calcular la amortización alemana
  List<Map<String, dynamic>> calcularAleman(double monto, double tasa, int periodos) {
    List<Map<String, dynamic>> tabla = [];
    double capitalConstante = monto / periodos;
    double saldo = monto;

    for (int i = 1; i <= periodos; i++) {
      double interes = saldo * (tasa / 100 / 12); // Tasa mensual
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
  List<Map<String, dynamic>> calcularFrances(double monto, double tasa, int periodos) {
    List<Map<String, dynamic>> tabla = [];
    double tasaMensual = tasa / 100 / 12;
    double cuota = monto * (tasaMensual * pow(1 + tasaMensual, periodos)) / 
                  (pow(1 + tasaMensual, periodos) - 1);
    double saldo = monto;

    for (int i = 1; i <= periodos; i++) {
      double interes = saldo * tasaMensual;
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
  List<Map<String, dynamic>> calcularAmericano(double monto, double tasa, int periodos) {
    List<Map<String, dynamic>> tabla = [];
    double interesPeriodico = monto * (tasa / 100 / 12);

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
}