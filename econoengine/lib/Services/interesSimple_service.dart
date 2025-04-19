class InteresSimpleService {
  // Cálculo del Valor Futuro (VF = VP * (1 + i * t))
  double calcularVF(double vp, double i, double t, {
    String unidadTiempo = 'años',
    String unidadTasa = 'anual',
  }) {
    final tConvertido = _convertirTiempo(t, unidadTiempo);
    final iConvertida = _convertirTasa(i, unidadTasa);
    return vp * (1 + (iConvertida / 100) * tConvertido);
  }

  // Cálculo del Valor Presente (VP = VF / (1 + i * t))
  double calcularVP(double vf, double i, double t, {
    String unidadTiempo = 'años',
    String unidadTasa = 'anual',
  }) {
    final tConvertido = _convertirTiempo(t, unidadTiempo);
    final iConvertida = _convertirTasa(i, unidadTasa);
    return vf / (1 + (iConvertida / 100) * tConvertido);
  }

  // Cálculo de la Tasa de Interés (i = ((VF/VP) - 1) / t * 100)
  double calcularTasa(double vp, double vf, double t, {
    String unidadTiempo = 'años',
    String unidadTasa = 'anual',
  }) {
    final tConvertido = _convertirTiempo(t, unidadTiempo);
    final tasaAnual = ((vf / vp) - 1) / tConvertido * 100;
    return _convertirTasaInversa(tasaAnual, unidadTasa);
  }

  // Cálculo del Tiempo (t = ((VF/VP) - 1) / i)
  double calcularTiempo(double vp, double vf, double i, {
    String unidadTiempo = 'años',
    String unidadTasa = 'anual',
  }) {
    final iConvertida = _convertirTasa(i, unidadTasa);
    final tiempoEnAnios = ((vf / vp) - 1) / (iConvertida / 100);
    return _convertirTiempoInverso(tiempoEnAnios, unidadTiempo);
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

  // Validación genérica de campos
  String validarCampos({
    required double? vp,
    required double? vf,
    required double? i,
    required double? t,
    required List<bool> requeridos,
  }) {
    if (requeridos[0] && (vp == null || vp <= 0)) return 'VP inválido';
    if (requeridos[1] && (vf == null || vf <= 0)) return 'VF inválido';
    if (requeridos[2] && (i == null || i <= 0)) return 'Tasa inválida';
    if (requeridos[3] && (t == null || t <= 0)) return 'Tiempo inválido';
    return '';
  }
}