import 'package:flutter/material.dart';
import '../services/inflacion_service.dart';

class InflacionController extends ChangeNotifier {
  final InflacionService _service = InflacionService();
  
  String _modoSeleccionado = 'Pérdida de valor';
  dynamic _resultados;
  String _error = '';
  
  // Getters
  String get modoSeleccionado => _modoSeleccionado;
  dynamic get resultados => _resultados;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;
  
  // Cambiar modo de cálculo
  void cambiarModo(String nuevoModo) {
    _modoSeleccionado = nuevoModo;
    _resultados = null;
    _error = '';
    notifyListeners();
  }
  
  // Calcular según el modo seleccionado
  void calcularPerdidaValor({
    required double montoInicial,
    required double tasaInflacionAnual,
    required int anos,
  }) {
    try {
      _error = '';
      _resultados = _service.calcularPerdidaValor(
        montoInicial: montoInicial,
        tasaInflacionAnual: tasaInflacionAnual / 100,
        anos: anos,
      );
      notifyListeners();
    } catch (e) {
      _error = 'Error al calcular pérdida de valor: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void ajustarPrecioHistorico({
    required double precioOriginal,
    required double tasaInflacionAnual,
    required int anos,
  }) {
    try {
      _error = '';
      _resultados = _service.ajustarPrecioHistorico(
        precioOriginal: precioOriginal,
        tasaInflacionAnual: tasaInflacionAnual / 100,
        anos: anos,
      );
      notifyListeners();
    } catch (e) {
      _error = 'Error al ajustar precio histórico: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void calcularAumentoPrecio({
    required double precioActual,
    required double tasaInflacionAnual,
    required int anos,
  }) {
    try {
      _error = '';
      _resultados = _service.calcularAumentoPrecio(
        precioActual: precioActual,
        tasaInflacionAnual: tasaInflacionAnual / 100,
        anos: anos,
      );
      notifyListeners();
    } catch (e) {
      _error = 'Error al calcular aumento de precio: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void simularInflacionAcumulada({
    required double montoInicial,
    required List<double> tasasInflacionAnuales,
  }) {
    try {
      _error = '';
      if (tasasInflacionAnuales.isEmpty) {
        throw Exception('Ingrese al menos una tasa de inflación');
      }
      
      _resultados = _service.simularInflacionAcumulada(
        montoInicial: montoInicial,
        tasasInflacionAnuales: tasasInflacionAnuales.map((t) => t / 100).toList(),
      );
      notifyListeners();
    } catch (e) {
      _error = 'Error en simulación de inflación: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void compararEscenariosInversion({
    required double montoInicial,
    required double tasaInflacionAnual,
    required int anos,
    required double tasaInteresInversion,
    double? aportesAnuales,
  }) {
    try {
      _error = '';
      _resultados = _service.compararEscenariosInversion(
        montoInicial: montoInicial,
        tasaInflacionAnual: tasaInflacionAnual / 100,
        anos: anos,
        tasaInteresInversion: tasaInteresInversion / 100,
        aportesAnuales: aportesAnuales,
      );
      notifyListeners();
    } catch (e) {
      _error = 'Error al comparar escenarios: ${e.toString()}';
      notifyListeners();
    }
  }
}