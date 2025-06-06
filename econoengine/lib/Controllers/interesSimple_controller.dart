import 'package:flutter/material.dart';
import '../Services/interesSimple_service.dart';

class InteresSimpleController extends ChangeNotifier {
  final InteresSimpleService _service = InteresSimpleService();
  
  // Variables de estado
  String _resultado = '';
  String _error = '';
  int _camposLlenos = 0;
  String _unidadTiempo = 'años'; // Opciones: días, meses, trimestres, semestres, años
  String _unidadTasa = 'anual';  // Opciones: diaria, mensual, trimestral, semestral, anual

  // Getters
  String get resultado => _resultado;
  String get error => _error;
  bool get shouldShowError => _error.isNotEmpty;
  bool get tresCamposLlenos => _camposLlenos >= 3;
  String get unidadTiempo => _unidadTiempo;
  String get unidadTasa => _unidadTasa;

  // Setters para unidades
  void cambiarUnidadTiempo(String nuevaUnidad) {
    _unidadTiempo = nuevaUnidad;
    notifyListeners();
  }

  void cambiarUnidadTasa(String nuevaUnidad) {
    _unidadTasa = nuevaUnidad;
    notifyListeners();
  }

  // Actualizar conteo de campos llenos
  void actualizarCamposLlenos(int llenos) {
    _camposLlenos = llenos;
    notifyListeners();
  }

  // --- Métodos de cálculo ---
  void calcularVF(double? vp, double? i, double? t) {
    _error = _service.validarCampos(
      vp: vp, vf: null, i: i, t: t,
      requeridos: [true, false, true, true]
    );

    if (_error.isNotEmpty) {
      notifyListeners();
      return;
    }

    _resultado = 'Monto Futuro (VF): \$${_service.calcularVF(
      vp!,
      i!,
      t!,
      unidadTiempo: _unidadTiempo,
      unidadTasa: _unidadTasa,
    ).toStringAsFixed(2)}';
    notifyListeners();
  }

  void calcularVP(double? vf, double? i, double? t) {
    _error = _service.validarCampos(
      vp: null, vf: vf, i: i, t: t,
      requeridos: [false, true, true, true]
    );

    if (_error.isNotEmpty) {
      notifyListeners();
      return;
    }

    _resultado = 'Valor Presente (VP): \$${_service.calcularVP(
      vf!,
      i!,
      t!,
      unidadTiempo: _unidadTiempo,
      unidadTasa: _unidadTasa,
    ).toStringAsFixed(2)}';
    notifyListeners();
  }

  void calcularTasa(double? vp, double? vf, double? t) {
    _error = _service.validarCampos(
      vp: vp, vf: vf, i: null, t: t,
      requeridos: [true, true, false, true]
    );

    if (_error.isNotEmpty) {
      notifyListeners();
      return;
    }

    _resultado = 'Tasa de Interés (i): ${_service.calcularTasa(
      vp!,
      vf!,
      t!,
      unidadTiempo: _unidadTiempo,
      unidadTasa: _unidadTasa,
    ).toStringAsFixed(2)}% ($_unidadTasa)';
    notifyListeners();
  }

  void calcularTiempo(double? vp, double? vf, double? i) {
    _error = _service.validarCampos(
      vp: vp, vf: vf, i: i, t: null,
      requeridos: [true, true, true, false]
    );

    if (_error.isNotEmpty) {
      notifyListeners();
      return;
    }

    _resultado = 'Tiempo (t): ${_service.calcularTiempo(
      vp!,
      vf!,
      i!,
      unidadTiempo: _unidadTiempo,
      unidadTasa: _unidadTasa,
    ).toStringAsFixed(2)} $_unidadTiempo';
    notifyListeners();
  }

  // Limpiar resultados y errores
  void limpiarResultados() {
    _resultado = '';
    _error = '';
    notifyListeners();
  }
}