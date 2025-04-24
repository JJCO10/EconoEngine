import 'package:flutter/material.dart';
import '../Services/uvr_service.dart';

class UvrController extends ChangeNotifier {
  final UvrService _service = UvrService();

  String _modoSeleccionado = 'Variación UVR';
  dynamic _resultado;
  String _error = '';

  String get modoSeleccionado => _modoSeleccionado;
  dynamic get resultado => _resultado;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;
  bool get tieneResultado => _resultado != null;

  void cambiarModo(String nuevoModo) {
    _modoSeleccionado = nuevoModo;
    _resultado = null;
    _error = '';
    notifyListeners();
  }

  // Solo este método devuelve un porcentaje (tasa efectiva anual)
  void calcularVariacionUvr(double valorInicial, double valorFinal,
      DateTime fechaInicial, DateTime fechaFinal) {
    try {
      _error = '';
      _resultado = {
        'variacionPorcentual': _service.calcularVariacionUvr(
            valorInicial, valorFinal, fechaInicial, fechaFinal),
        'valorInicial': valorInicial,
        'valorFinal': valorFinal,
        'dias': fechaFinal.difference(fechaInicial).inDays
      };
      notifyListeners();
    } catch (e) {
      _error = 'Error al calcular variación UVR: ${e.toString()}';
      notifyListeners();
    }
  }

  // Devuelve valor absoluto en UVR
  void convertirPesosAUvr(double valorPesos, double valorUvr) {
    try {
      _error = '';
      _resultado = {
        'valorPesos': valorPesos,
        'valorUvr': valorUvr,
        'resultado': _service.convertirPesosAUvr(valorPesos, valorUvr)
      };
      notifyListeners();
    } catch (e) {
      _error = 'Error al convertir Pesos a UVR: ${e.toString()}';
      notifyListeners();
    }
  }

  // Devuelve valor absoluto en pesos
  void convertirUvrAPesos(double valorUvr, double valorActualUvr) {
    try {
      _error = '';
      _resultado = {
        'valorUvr': valorUvr,
        'valorActualUvr': valorActualUvr,
        'resultado': _service.convertirUvrAPesos(valorUvr, valorActualUvr)
      };
      notifyListeners();
    } catch (e) {
      _error = 'Error al convertir UVR a Pesos: ${e.toString()}';
      notifyListeners();
    }
  }

  // Devuelve valores absolutos (UVR y pesos)
  void calcularCuotaCreditoUvr(
      double montoUvr, double tasaInteresEA, int plazoMeses, double valorUvr) {
    try {
      _error = '';
      double cuotaUvr =
          _service.calcularCuotaCreditoUvr(montoUvr, tasaInteresEA, plazoMeses);

      _resultado = {
        'montoUvr': montoUvr,
        'tasaInteresEA': tasaInteresEA,
        'plazoMeses': plazoMeses,
        'cuotaUvr': cuotaUvr,
        'cuotaPesos': cuotaUvr * valorUvr,
        'valorUvr': valorUvr
      };

      notifyListeners();
    } catch (e) {
      _error = 'Error al calcular cuota de crédito UVR: ${e.toString()}';
      notifyListeners();
    }
  }

  // Devuelve valor absoluto proyectado
  void proyectarUvr(double valorActualUvr, double inflacionAnualProyectada,
      DateTime fechaActual, DateTime fechaFutura) {
    try {
      _error = '';
      int dias = fechaFutura.difference(fechaActual).inDays;

      _resultado = {
        'valorActualUvr': valorActualUvr,
        'valorProyectado': _service.proyectarUvr(
            valorActualUvr, inflacionAnualProyectada, dias),
        'inflacionAnualProyectada': inflacionAnualProyectada,
        'diasProyectados': dias
      };

      notifyListeners();
    } catch (e) {
      _error = 'Error al proyectar UVR: ${e.toString()}';
      notifyListeners();
    }
  }

  // Devuelve tabla con valores absolutos
  // En UvrController
  void generarTablaAmortizacionUvr(
      double capital,
      double cuotaInicial,
      double valorUvr,
      double tasaInteresEA,
      int plazoMeses,
      double inflacionAnualProyectada) {
    try {
      _error = '';

      double montoUvr = _service.convertirPesosAUvr(
          cuotaInicial > 0 ? capital - cuotaInicial : capital, valorUvr);

      var tabla = _service.generarTablaAmortizacionUvr(montoUvr, valorUvr,
          tasaInteresEA, plazoMeses, inflacionAnualProyectada);

      // Creamos un objeto de resultado más estructurado
      _resultado = {
        'resumen': {
          'Monto inicial (UVR)': montoUvr.toStringAsFixed(4),
          'Valor UVR inicial': valorUvr.toStringAsFixed(4),
          'Tasa interés EA': '${(tasaInteresEA * 100).toStringAsFixed(2)}%',
          'Plazo (meses)': plazoMeses,
          'Inflación proyectada':
              '${(inflacionAnualProyectada * 100).toStringAsFixed(2)}%',
          'Cuota fija (UVR)': _service
              .calcularCuotaCreditoUvr(montoUvr, tasaInteresEA, plazoMeses)
              .toStringAsFixed(4),
        },
        'tabla': tabla,
        'encabezados': [
          'Mes',
          'Valor UVR',
          'Cuota UVR',
          'Interés UVR',
          'Abono Capital UVR',
          'Saldo UVR',
          'Cuota Pesos',
          'Interés Pesos',
          'Abono Capital Pesos',
          'Saldo Pesos'
        ],
      };

      notifyListeners();
    } catch (e) {
      _error = 'Error al generar tabla de amortización: ${e.toString()}';
      notifyListeners();
    }
  }
}
