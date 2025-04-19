import 'package:flutter/material.dart';
import '../Services/amortizacion_service.dart';

class AmortizacionController extends ChangeNotifier {
  final AmortizacionService _service = AmortizacionService();
  
  // Variables de estado
  String _metodoSeleccionado = 'Alemán';
  String _unidadTasa = 'anual';
  String _unidadPeriodo = 'meses';
  List<Map<String, dynamic>> _tablaAmortizacion = [];
  String _error = '';

  // Getters
  String get metodoSeleccionado => _metodoSeleccionado;
  String get unidadTasa => _unidadTasa;
  String get unidadPeriodo => _unidadPeriodo;
  List<Map<String, dynamic>> get tablaAmortizacion => _tablaAmortizacion;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  // Cambiar método de amortización
  void cambiarMetodo(String nuevoMetodo) {
    _metodoSeleccionado = nuevoMetodo;
    _tablaAmortizacion = [];
    _error = '';
    notifyListeners();
  }

  // Cambiar unidad de tasa
  void cambiarUnidadTasa(String nuevaUnidad) {
    _unidadTasa = nuevaUnidad;
    _tablaAmortizacion = [];
    _error = '';
    notifyListeners();
  }

  // Cambiar unidad de periodo
  void cambiarUnidadPeriodo(String nuevaUnidad) {
    _unidadPeriodo = nuevaUnidad;
    _tablaAmortizacion = [];
    _error = '';
    notifyListeners();
  }

  // Calcular amortización
  void calcularAmortizacion(double monto, double tasa, int periodos) {
    try {
      _error = '';
      
      if (monto <= 0 || tasa <= 0 || periodos <= 0) {
        throw Exception('Todos los valores deben ser mayores a cero');
      }

      switch (_metodoSeleccionado) {
        case 'Alemán':
          _tablaAmortizacion = _service.calcularAleman(
            monto, 
            tasa, 
            periodos,
            unidadTasa: _unidadTasa,
            unidadPeriodo: _unidadPeriodo,
          );
          break;
        case 'Francés':
          _tablaAmortizacion = _service.calcularFrances(
            monto, 
            tasa, 
            periodos,
            unidadTasa: _unidadTasa,
            unidadPeriodo: _unidadPeriodo,
          );
          break;
        case 'Americano':
          _tablaAmortizacion = _service.calcularAmericano(
            monto, 
            tasa, 
            periodos,
            unidadTasa: _unidadTasa,
            unidadPeriodo: _unidadPeriodo,
          );
          break;
      }
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _tablaAmortizacion = [];
      notifyListeners();
    }
  }
}