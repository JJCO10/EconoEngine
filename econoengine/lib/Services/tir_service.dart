import 'dart:math';

class TirService {
  // Método para calcular la TIR tradicional
  double calcularTIR(List<double> flujos, {int maxIteraciones = 1000, double tolerancia = 0.00001}) {
    double tir = 0.1; // Valor inicial estimado
    double diferencia = double.infinity;
    
    for (int i = 0; i < maxIteraciones && diferencia.abs() > tolerancia; i++) {
      double valorActual = _calcularVAN(flujos, tir);
      double derivada = _calcularDerivadaVAN(flujos, tir);
      
      if (derivada == 0) break;
      
      double nuevaTir = tir - valorActual / derivada;
      diferencia = nuevaTir - tir;
      tir = nuevaTir;
    }
    
    return tir;
  }

  // Método para calcular la TIRM (TIR Modificada)
  double calcularTIRM(List<double> flujos, double tasaReinversion, double tasaFinanciamiento) {
    double valorPositivo = 0;
    double valorNegativo = 0;
    
    for (int i = 0; i < flujos.length; i++) {
      if (flujos[i] > 0) {
        valorPositivo += flujos[i] / pow(1 + tasaReinversion, flujos.length - i - 1);
      } else {
        valorNegativo += flujos[i] / pow(1 + tasaFinanciamiento, i);
      }
    }
    
    return pow(valorPositivo / -valorNegativo, 1 / flujos.length) - 1;
  }

  // Método para calcular la TRA (Tasa de Retorno Contable)
  double calcularTRA(double beneficioNetoPromedio, double inversionInicial) {
    return beneficioNetoPromedio / inversionInicial;
  }

  // Método para calcular la TRR (Tasa de Retorno Requerida)
  double calcularTRR(double tasaLibreRiesgo, double primaRiesgo, double beta) {
    return tasaLibreRiesgo + (beta * primaRiesgo);
  }

  // Método para calcular la Tasa de Retorno Real
  double calcularRetornoReal(double retornoNominal, double inflacion) {
    return (1 + retornoNominal) / (1 + inflacion) - 1;
  }

  // Método para calcular la Tasa de Retorno Esperada
  double calcularRetornoEsperado(List<double> posiblesRetornos, List<double> probabilidades) {
    if (posiblesRetornos.length != probabilidades.length) {
      throw ArgumentError('Los retornos y probabilidades deben tener la misma longitud');
    }
    
    double suma = 0;
    for (int i = 0; i < posiblesRetornos.length; i++) {
      suma += posiblesRetornos[i] * probabilidades[i];
    }
    
    return suma;
  }

  // Métodos auxiliares
  double _calcularVAN(List<double> flujos, double tasa) {
    double van = 0;
    for (int i = 0; i < flujos.length; i++) {
      van += flujos[i] / pow(1 + tasa, i);
    }
    return van;
  }

  double _calcularDerivadaVAN(List<double> flujos, double tasa) {
    double derivada = 0;
    for (int i = 1; i < flujos.length; i++) {
      derivada -= i * flujos[i] / pow(1 + tasa, i + 1);
    }
    return derivada;
  }
}