import 'dart:math';

class InteresCompuestoService {
  // Cálculo del Monto Compuesto (MC = C * (1 + i)^n)
  double calcularMontoCompuesto(double capital, double tasa, double tiempo, {
    String unidadTiempo = 'años',
    String unidadTasa = 'anual',
  }) {
    final tConvertido = _convertirTiempo(tiempo, unidadTiempo);
    final iConvertida = _convertirTasa(tasa, unidadTasa);
    return capital * pow(1 + (iConvertida / 100), tConvertido);
  }

  // Cálculo del Tiempo (n = log(MC/C) / log(1+i))
  double calcularTiempo(double capital, double montoCompuesto, double tasa, {
    String unidadTiempo = 'años',
    String unidadTasa = 'anual',
  }) {
    final iConvertida = _convertirTasa(tasa, unidadTasa);
    final tiempoEnAnios = (log(montoCompuesto) - log(capital)) / log(1 + (iConvertida / 100));
    return _convertirTiempoInverso(tiempoEnAnios, unidadTiempo);
  }

  // Cálculo de la Tasa de Interés (i = (MC/C)^(1/n) - 1)
  double calcularTasaInteres(double capital, double montoCompuesto, double tiempo, {
    String unidadTiempo = 'años',
    String unidadTasa = 'anual',
  }) {
    final tConvertido = _convertirTiempo(tiempo, unidadTiempo);
    final tasaAnual = ((pow(montoCompuesto / capital, 1 / tConvertido) as double) - 1) * 100;
    return _convertirTasaInversa(tasaAnual, unidadTasa);
  }

  // --- Conversiones para el tiempo ---
  double _convertirTiempo(double t, String unidadTiempo) {
    switch (unidadTiempo) {
      case 'días':
        return t / 365;
      case 'meses':
        return t / 12;
      case 'trimestres':
        return t / 4;
      case 'semestres':
        return t / 2;
      default: // años
        return t;
    }
  }

  double _convertirTiempoInverso(double tAnios, String unidadTiempo) {
    switch (unidadTiempo) {
      case 'días':
        return tAnios * 365;
      case 'meses':
        return tAnios * 12;
      case 'trimestres':
        return tAnios * 4;
      case 'semestres':
        return tAnios * 2;
      default: // años
        return tAnios;
    }
  }

  // --- Conversiones para la tasa ---
  double _convertirTasa(double tasa, String unidadTasa) {
    switch (unidadTasa) {
      case 'mensual':
        return tasa * 12;
      case 'trimestral':
        return tasa * 4;
      case 'semestral':
        return tasa * 2;
      case 'diaria':
        return tasa * 365;
      default: // anual
        return tasa;
    }
  }

  double _convertirTasaInversa(double tasaAnual, String unidadTasa) {
    switch (unidadTasa) {
      case 'mensual':
        return tasaAnual / 12;
      case 'trimestral':
        return tasaAnual / 4;
      case 'semestral':
        return tasaAnual / 2;
      case 'diaria':
        return tasaAnual / 365;
      default: // anual
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
    if (requeridos[0] && (capital == null || capital <= 0)) return 'Capital inválido';
    if (requeridos[1] && (montoCompuesto == null || montoCompuesto <= 0)) return 'Monto inválido';
    if (requeridos[2] && (tasa == null || tasa <= 0)) return 'Tasa inválida';
    if (requeridos[3] && (tiempo == null || tiempo <= 0)) return 'Tiempo inválido';
    return '';
  }
}