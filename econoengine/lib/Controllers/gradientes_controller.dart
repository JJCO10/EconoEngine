import 'package:flutter/material.dart';
import '../Services/gradientes_service.dart';

class GradienteController extends ChangeNotifier {
  final GradienteService _service = GradienteService();
  
  String _tipoGradiente = "Aritmético";
  Map<String, double> _resultados = {};
  String _error = '';

  String get tipoGradiente => _tipoGradiente;
  Map<String, double> get resultados => _resultados;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  void cambiarTipoGradiente(String nuevoTipo) {
    _tipoGradiente = nuevoTipo;
    _resultados = {};
    _error = '';
    notifyListeners();
  }

  void calcular({
    required double primerPago,
    required double gradienteOrTasaCrecimiento,
    required double tasaInteres,
    required int periodos,
  }) {
    try {
      _error = '';
      
      if (_tipoGradiente == "Aritmético") {
        _resultados = _service.calcularAritmetico(
          primerPago, gradienteOrTasaCrecimiento, tasaInteres, periodos);
      } else {
        _resultados = _service.calcularGeometrico(
          primerPago, gradienteOrTasaCrecimiento, tasaInteres, periodos);
      }
      
      notifyListeners();
    } catch (e) {
      _error = 'Error en el cálculo: ${e.toString()}';
      notifyListeners();
    }
  }
}