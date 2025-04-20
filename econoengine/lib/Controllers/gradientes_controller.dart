import 'package:flutter/material.dart';
import '../Services/gradientes_service.dart';

class GradienteController extends ChangeNotifier {
  final GradienteService _service = GradienteService();
  
  String _tipoGradiente = "Aritmético";
  String _unidadTasa = 'anual';
  String _unidadPeriodo = 'meses';
  Map<String, double> _resultados = {};
  String _error = '';

  String get tipoGradiente => _tipoGradiente;
  String get unidadTasa => _unidadTasa;
  String get unidadPeriodo => _unidadPeriodo;
  Map<String, double> get resultados => _resultados;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  void cambiarTipoGradiente(String nuevoTipo) {
    _tipoGradiente = nuevoTipo;
    _resultados = {};
    _error = '';
    notifyListeners();
  }

  void cambiarUnidadTasa(String nuevaUnidad) {
    _unidadTasa = nuevaUnidad;
    _resultados = {};
    _error = '';
    notifyListeners();
  }

  void cambiarUnidadPeriodo(String nuevaUnidad) {
    _unidadPeriodo = nuevaUnidad;
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
          primerPago, 
          gradienteOrTasaCrecimiento, 
          tasaInteres, 
          periodos,
          unidadTasa: _unidadTasa,
          unidadPeriodo: _unidadPeriodo,
        );
      } else {
        _resultados = _service.calcularGeometrico(
          primerPago, 
          gradienteOrTasaCrecimiento, 
          tasaInteres, 
          periodos,
          unidadTasa: _unidadTasa,
          unidadPeriodo: _unidadPeriodo,
        );
      }
      
      notifyListeners();
    } catch (e) {
      _error = 'Error en el cálculo: ${e.toString()}';
      notifyListeners();
    }
  }
}