import 'package:econoengine/l10n/app_localizations_setup.dart';
import 'package:flutter/material.dart';
import '../Services/interesCompuesto_service.dart';

class InteresCompuestoController extends ChangeNotifier {
  final InteresCompuestoService _service = InteresCompuestoService();

  // Variables de estado
  String _resultado = '';
  String _error = '';
  int _camposLlenos = 0;
  String _unidadTiempo = 'years'; // Clave en inglés por defecto
  String _unidadTasa = 'annual'; // Clave en inglés por defecto
  // ... (getters) ...

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

  void initialize(BuildContext context) {
    notifyListeners();
  }

  // Métodos de cálculo
  void calcularMontoCompuesto(
      BuildContext context, double? capital, double? tasa, double? tiempo) {
    final errorKey = _service.validarCampos(
      capital: capital,
      montoCompuesto: null,
      tasa: tasa,
      tiempo: tiempo,
      requeridos: [true, false, true, true],
    );

    if (errorKey.isNotEmpty) {
      _error = AppLocalizations.of(context)!.translate(errorKey);
      notifyListeners();
      return;
    }

    final mc = _service.calcularMontoCompuesto(
      capital!,
      tasa!,
      tiempo!,
      unidadTiempo: _unidadTiempo,
      unidadTasa: _unidadTasa,
    );
    _resultado = 'Monto Compuesto (MC): \$${mc.toStringAsFixed(2)}';
    notifyListeners();
  }

  void calcularTiempo(BuildContext context, double? capital,
      double? montoCompuesto, double? tasa) {
    final errorKey = _service.validarCampos(
      capital: capital,
      montoCompuesto: montoCompuesto,
      tasa: tasa,
      tiempo: null,
      requeridos: [true, true, true, false],
    );

    if (errorKey.isNotEmpty) {
      _error = AppLocalizations.of(context)!.translate(errorKey);
      notifyListeners();
      return;
    }

    final n = _service.calcularTiempo(
      capital!,
      montoCompuesto!,
      tasa!,
      unidadTiempo: _unidadTiempo,
      unidadTasa: _unidadTasa,
    );
    _resultado = 'Tiempo (n): ${n.toStringAsFixed(2)} $_unidadTiempo';
    notifyListeners();
  }

  void calcularTasaInteres(BuildContext context, double? capital,
      double? montoCompuesto, double? tiempo) {
    final errorKey = _service.validarCampos(
      capital: capital,
      montoCompuesto: montoCompuesto,
      tasa: null,
      tiempo: tiempo,
      requeridos: [true, true, false, true],
    );

    if (errorKey.isNotEmpty) {
      _error = AppLocalizations.of(context)!.translate(errorKey);
      notifyListeners();
      return;
    }

    final i = _service.calcularTasaInteres(
      capital!,
      montoCompuesto!,
      tiempo!,
      unidadTiempo: _unidadTiempo,
      unidadTasa: _unidadTasa,
    );
    _resultado = 'Tasa de Interés (i): ${i.toStringAsFixed(2)}% ($_unidadTasa)';
    notifyListeners();
  }
}
