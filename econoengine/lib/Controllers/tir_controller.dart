import 'package:flutter/material.dart';
import '../Services/tir_service.dart';

class TirController extends ChangeNotifier {
  final TirService _service = TirService();
  
  String _modoSeleccionado = 'TIR';
  List<double> _flujos = [];
  double _resultado = 0;
  String _error = '';
  
  // Getters
  String get modoSeleccionado => _modoSeleccionado;
  double get resultado => _resultado;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;
  
  // Cambiar modo de cálculo
  void cambiarModo(String nuevoModo) {
    _modoSeleccionado = nuevoModo;
    _resultado = 0;
    _error = '';
    notifyListeners();
  }
  
  // Calcular según el modo seleccionado
  void calcularTIR(List<double> flujos) {
    try {
      _error = '';
      if (flujos.isEmpty) throw Exception('Ingrese al menos un flujo de caja');
      
      _resultado = _service.calcularTIR(flujos) * 100;
      notifyListeners();
    } catch (e) {
      _error = 'Error al calcular TIR: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void calcularTIRM(List<double> flujos, double tasaReinversion, double tasaFinanciamiento) {
    try {
      _error = '';
      if (flujos.isEmpty) throw Exception('Ingrese al menos un flujo de caja');
      
      _resultado = _service.calcularTIRM(flujos, tasaReinversion, tasaFinanciamiento) * 100;
      notifyListeners();
    } catch (e) {
      _error = 'Error al calcular TIRM: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void calcularTRA(double beneficioNetoPromedio, double inversionInicial) {
    try {
      _error = '';
      if (inversionInicial <= 0) throw Exception('La inversión inicial debe ser mayor a cero');
      
      _resultado = _service.calcularTRA(beneficioNetoPromedio, inversionInicial) * 100;
      notifyListeners();
    } catch (e) {
      _error = 'Error al calcular TRA: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void calcularTRR(double tasaLibreRiesgo, double primaRiesgo, double beta) {
    try {
      _error = '';
      _resultado = _service.calcularTRR(tasaLibreRiesgo, primaRiesgo, beta) * 100;
      notifyListeners();
    } catch (e) {
      _error = 'Error al calcular TRR: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void calcularRetornoReal(double retornoNominal, double inflacion) {
    try {
      _error = '';
      _resultado = _service.calcularRetornoReal(retornoNominal, inflacion) * 100;
      notifyListeners();
    } catch (e) {
      _error = 'Error al calcular retorno real: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void calcularRetornoEsperado(List<double> posiblesRetornos, List<double> probabilidades) {
    try {
      _error = '';
      if (posiblesRetornos.isEmpty) throw Exception('Ingrese al menos un posible retorno');
      if (posiblesRetornos.length != probabilidades.length) {
        throw Exception('Retornos y probabilidades deben tener la misma cantidad');
      }
      
      _resultado = _service.calcularRetornoEsperado(posiblesRetornos, probabilidades) * 100;
      notifyListeners();
    } catch (e) {
      _error = 'Error al calcular retorno esperado: ${e.toString()}';
      notifyListeners();
    }
  }
}