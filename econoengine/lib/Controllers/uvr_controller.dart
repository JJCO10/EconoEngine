import 'package:flutter/material.dart';
import '../Services/uvr_service.dart';

class UvrController extends ChangeNotifier {
  final UvrService _service = UvrService();
  
  String _modoSeleccionado = 'Variación UVR';
  dynamic _resultado;
  String _error = '';
  
  // Getters
  String get modoSeleccionado => _modoSeleccionado;
  dynamic get resultado => _resultado;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;
  bool get tieneResultado => _resultado != null;
  
  // Cambiar modo de cálculo
  void cambiarModo(String nuevoModo) {
    _modoSeleccionado = nuevoModo;
    _resultado = null;
    _error = '';
    notifyListeners();
  }
  
  // Calcular según el modo seleccionado
  void calcularVariacionUvr(double valorInicial, double valorFinal, DateTime fechaInicial, DateTime fechaFinal) {
    try {
      _error = '';
      if (valorInicial <= 0 || valorFinal <= 0) {
        throw Exception('Los valores de UVR deben ser mayores a cero');
      }
      
      _resultado = _service.calcularVariacionUvr(valorInicial, valorFinal, fechaInicial, fechaFinal);
      notifyListeners();
    } catch (e) {
      _error = 'Error al calcular variación UVR: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void convertirPesosAUvr(double valorPesos, double valorUvr) {
    try {
      _error = '';
      if (valorUvr <= 0) {
        throw Exception('El valor de UVR debe ser mayor a cero');
      }
      
      _resultado = _service.convertirPesosAUvr(valorPesos, valorUvr);
      notifyListeners();
    } catch (e) {
      _error = 'Error al convertir Pesos a UVR: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void convertirUvrAPesos(double valorUvr, double valorActualUvr) {
    try {
      _error = '';
      if (valorActualUvr <= 0) {
        throw Exception('El valor actual de UVR debe ser mayor a cero');
      }
      
      _resultado = _service.convertirUvrAPesos(valorUvr, valorActualUvr);
      notifyListeners();
    } catch (e) {
      _error = 'Error al convertir UVR a Pesos: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void calcularCuotaCreditoUvr(double montoUvr, double tasaInteresEA, int plazoMeses, double valorUvr) {
    try {
      _error = '';
      if (montoUvr <= 0 || valorUvr <= 0) {
        throw Exception('Los valores de monto y UVR deben ser mayores a cero');
      }
      if (plazoMeses <= 0) {
        throw Exception('El plazo debe ser mayor a cero');
      }
      
      double cuotaUvr = _service.calcularCuotaCreditoUvr(montoUvr, tasaInteresEA, plazoMeses);
      double cuotaPesos = cuotaUvr * valorUvr;
      
      _resultado = {
        'cuotaUvr': cuotaUvr,
        'cuotaPesos': cuotaPesos,
      };
      
      notifyListeners();
    } catch (e) {
      _error = 'Error al calcular cuota de crédito UVR: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void proyectarUvr(double valorActualUvr, double inflacionAnualProyectada, DateTime fechaActual, DateTime fechaFutura) {
    try {
      _error = '';
      if (valorActualUvr <= 0) {
        throw Exception('El valor actual de UVR debe ser mayor a cero');
      }
      
      int dias = fechaFutura.difference(fechaActual).inDays;
      if (dias <= 0) {
        throw Exception('La fecha futura debe ser posterior a la fecha actual');
      }
      
      _resultado = _service.proyectarUvr(valorActualUvr, inflacionAnualProyectada, dias);
      notifyListeners();
    } catch (e) {
      _error = 'Error al proyectar UVR: ${e.toString()}';
      notifyListeners();
    }
  }
  
  void generarTablaAmortizacionUvr(
      double capital, 
      double cuotaInicial, 
      double valorUvr, 
      double tasaInteresEA, 
      int plazoMeses, 
      double inflacionAnualProyectada) {
    try {
      _error = '';
      if (capital <= 0 || valorUvr <= 0) {
        throw Exception('Los valores de capital y UVR deben ser mayores a cero');
      }
      if (plazoMeses <= 0) {
        throw Exception('El plazo debe ser mayor a cero');
      }
      
      // Convertir capital en pesos a UVR
      double montoUvr;
      if (cuotaInicial > 0) {
        montoUvr = _service.convertirPesosAUvr(capital - cuotaInicial, valorUvr);
      } else {
        montoUvr = _service.convertirPesosAUvr(capital, valorUvr);
      }
      
      _resultado = _service.generarTablaAmortizacionUvr(
        montoUvr, 
        valorUvr, 
        tasaInteresEA, 
        plazoMeses, 
        inflacionAnualProyectada
      );
      
      notifyListeners();
    } catch (e) {
      _error = 'Error al generar tabla de amortización: ${e.toString()}';
      notifyListeners();
    }
  }
}