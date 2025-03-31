class InteresSimpleService {
  // Cálculo del Valor Futuro (VF = VP * (1 + i * t))
  double calcularVF(double vp, double i, double t) => vp * (1 + (i / 100) * t);

  // Cálculo del Valor Presente (VP = VF / (1 + i * t))
  double calcularVP(double vf, double i, double t) => vf / (1 + (i / 100) * t);

  // Cálculo de la Tasa de Interés (i = ((VF/VP) - 1) / t * 100)
  double calcularTasa(double vp, double vf, double t) => ((vf / vp) - 1) / t * 100;

  // Cálculo del Tiempo (t = ((VF/VP) - 1) / i)
  double calcularTiempo(double vp, double vf, double i) => ((vf / vp) - 1) / (i / 100);

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