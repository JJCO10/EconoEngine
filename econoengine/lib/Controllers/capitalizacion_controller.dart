import 'package:flutter/material.dart';
import '../services/capitalizacion_service.dart';

class CapitalizacionController extends ChangeNotifier {
  final CapitalizacionService _service = CapitalizacionService();
  
  String _sistemaSeleccionado = 'Individual';
  dynamic _resultados;
  String _error = '';
  
  // Getters
  String get sistemaSeleccionado => _sistemaSeleccionado;
  dynamic get resultados => _resultados;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;
  
  // Cambiar sistema de capitalización
  void cambiarSistema(String nuevoSistema) {
    _sistemaSeleccionado = nuevoSistema;
    _resultados = null;
    _error = '';
    notifyListeners();
  }
  
  // Calcular según el sistema seleccionado
  void calcularIndividual({
    required double aporteMensual,
    required double tasaInteres,
    required int plazoAnos,
    required double comisionAdministrativa,
  }) {
    try {
      _error = '';
      _resultados = _service.calcularIndividual(
        aporteMensual: aporteMensual,
        tasaInteres: tasaInteres / 100,
        plazoAnos: plazoAnos,
        comisionAdministrativa: comisionAdministrativa / 100,
      );
      notifyListeners();
    } catch (e) {
      _error = 'Error en cálculo individual: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void calcularColectiva({
    required List<double> aportes,
    required double tasaInteres,
    required int plazoAnos,
    required double comisionAdministrativa,
    required int participantes,
  }) {
    try {
      _error = '';
      _resultados = _service.calcularColectiva(
        aportes: aportes,
        tasaInteres: tasaInteres / 100,
        plazoAnos: plazoAnos,
        comisionAdministrativa: comisionAdministrativa / 100,
        participantes: participantes,
      );
      notifyListeners();
    } catch (e) {
      _error = 'Error en cálculo colectivo: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void calcularMixto({
    required double aporteMensual,
    required double tasaInteresCapitalizacion,
    required double tasaInteresReparto,
    required int plazoAnos,
    required double porcentajeCapitalizacion,
  }) {
    try {
      _error = '';
      _resultados = _service.calcularMixto(
        aporteMensual: aporteMensual,
        tasaInteresCapitalizacion: tasaInteresCapitalizacion / 100,
        tasaInteresReparto: tasaInteresReparto / 100,
        plazoAnos: plazoAnos,
        porcentajeCapitalizacion: porcentajeCapitalizacion / 100,
      );
      notifyListeners();
    } catch (e) {
      _error = 'Error en cálculo mixto: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void calcularSeguros({
    required double prima,
    required double tasaInteres,
    required int plazoAnos,
    required double comisionAdministrativa,
    required double costoSeguro,
    required int frecuenciaPago,
  }) {
    try {
      _error = '';
      _resultados = _service.calcularSeguros(
        prima: prima,
        tasaInteres: tasaInteres / 100,
        plazoAnos: plazoAnos,
        comisionAdministrativa: comisionAdministrativa / 100,
        costoSeguro: costoSeguro,
        frecuenciaPago: frecuenciaPago,
      );
      notifyListeners();
    } catch (e) {
      _error = 'Error en cálculo de seguros: ${e.toString()}';
      notifyListeners();
    }
  }
}