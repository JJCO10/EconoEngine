import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econoengine/Models/cuota.dart';
import 'package:econoengine/Models/transferencia.dart';
import 'package:flutter/material.dart';
import '../Services/auth_service.dart';
import '../Services/biometric_auth_service.dart';
import '../Models/users.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:econoengine/Models/prestamo.dart';
import 'package:econoengine/Services/loan_service.dart';

class AuthController extends ChangeNotifier {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BiometricAuthService _biometricAuthService = BiometricAuthService();
  // Agrega como propiedad de la clase
  final LoanService _loanService = LoanService();

  // Agrega estos métodos
  Future<List<Prestamo>> obtenerPrestamosUsuario() async {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Usuario no autenticado');
      return [];
    }

    print('Buscando préstamos para el UID: ${user.uid}');

    final snapshot = await FirebaseFirestore.instance
        .collection('prestamos')
        .where('userId', isEqualTo: user.uid)
        .get();

    print('Préstamos encontrados: ${snapshot.docs.length}');

    return snapshot.docs.map((doc) {
      print('Prestamo encontrado: ${doc.data()}');
      return Prestamo.fromFirestore(doc);
    }).toList();
  }

  Stream<Prestamo> obtenerPrestamoPorId(String id) {
    return FirebaseFirestore.instance
        .collection('prestamos')
        .doc(id)
        .snapshots()
        .map((doc) => Prestamo.fromMap(doc.data()!, doc.id));
  }

  Future<void> actualizarSaldoUsuario(double nuevoSaldo) async {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    try {
      await _firestore.collection('usuarios').doc(user.uid).update({
        'Saldo': nuevoSaldo,
      });
      print('Saldo actualizado correctamente');
    } catch (e) {
      print('Error al actualizar el saldo: $e');
      rethrow;
    }
  }

  Future<void> solicitarPrestamo({
    required double monto,
    required String tipoInteres,
    required double tasaInteres,
    required int plazoMeses,
    required String destinoTelefono,
    required String solicitanteCedula,
    required String solicitanteNombre,
    required String estado,
    String? tipoGradiente,
    String? tipoAmortizacion,
    double? valorGradiente,
  }) async {
    try {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      await _loanService.solicitarPrestamo(
        userId: user.uid,
        monto: monto,
        tipoInteres: tipoInteres,
        tasaInteres: tasaInteres,
        plazoMeses: plazoMeses,
        destinoTelefono: destinoTelefono,
        solicitanteCedula: solicitanteCedula,
        solicitanteNombre: solicitanteNombre,
        estado: estado,
        tipoGradiente: tipoGradiente,
        tipoAmortizacion: tipoAmortizacion,
        valorGradiente: valorGradiente,
      );

      print('AuthController - Préstamo solicitado y guardado');
    } catch (e) {
      print('AuthController - Error al solicitar préstamo: $e');
      rethrow;
    }
  }

  Future<void> pagarCuota(String prestamoId, int numeroCuota) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    final userRef = _db.collection('usuarios').doc(user.uid);
    final prestamoRef = _db.collection('prestamos').doc(prestamoId);

    await _db.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);
      final prestamoSnapshot = await transaction.get(prestamoRef);

      if (!userSnapshot.exists || !prestamoSnapshot.exists) {
        throw Exception('Datos no encontrados');
      }

      // Usa .toDouble() para convertir seguro cualquier num a double
      final saldo = (userSnapshot.get('Saldo') as num).toDouble();
      final data = prestamoSnapshot.data()!;
      final cuotas = List<Map<String, dynamic>>.from(data['cuotas']);
      final cuota = cuotas.firstWhere((c) => c['numero'] == numeroCuota);

      if (cuota['estado'] == 'pagada') throw Exception('Cuota ya pagada');

      final montoCuota =
          (cuota['monto'] as num).toDouble(); // Conversión segura

      if (saldo < montoCuota) {
        throw Exception('Saldo insuficiente');
      }

      // Actualizar cuota
      cuota['estado'] = 'pagada';

      // Recalcular saldos (conversión segura)
      final nuevoSaldoPendiente =
          (data['saldoPendiente'] as num).toDouble() - montoCuota;
      final nuevoTotalPagado =
          (data['totalPagado'] as num).toDouble() + montoCuota;

      // Revisar si todas las cuotas están pagadas
      final todasPagadas = cuotas.every((c) => c['estado'] == 'pagada');
      final nuevoEstado = todasPagadas ? 'pagado' : data['estado'];

      // Actualizar préstamo
      transaction.update(prestamoRef, {
        'cuotas': cuotas,
        'saldoPendiente': nuevoSaldoPendiente < 0 ? 0 : nuevoSaldoPendiente,
        'totalPagado': nuevoTotalPagado,
        'estado': nuevoEstado,
      });

      // Descontar del saldo del usuario
      transaction.update(userRef, {
        'Saldo': saldo - montoCuota,
      });
    });
  }

  List<Cuota> calcularCuotasPrestamo({
    required double monto,
    required double tasaAnual,
    required int plazoMeses,
    required String tipoInteres,
    required String tipoGradiente,
    required String tipoAmortizacion,
    required double valorGradiente,
  }) {
    switch (tipoInteres) {
      case 'simple':
        return _calcularCuotasSimple(monto, tasaAnual, plazoMeses);

      case 'compuesto':
        return _calcularCuotasCompuesto(monto, tasaAnual, plazoMeses);

      case 'gradiente':
        // ignore: unnecessary_null_comparison
        if (tipoGradiente == null) {
          throw Exception('Debe especificar el tipo de gradiente');
        }
        return _calcularCuotasGradiente(
          primerPago: monto,
          tasaInteres: tasaAnual,
          periodos: plazoMeses,
          gradienteOrTasaCrecimiento:
              valorGradiente, // puedes reemplazar 10 por un valor recibido desde el formulario
          tipoGradiente: tipoGradiente,
        );

      case 'amortizacion':
        // ignore: unnecessary_null_comparison
        if (tipoAmortizacion == null) {
          throw Exception('Debe especificar el tipo de amortización');
        }
        return _calcularCuotasAmortizacion(
          monto,
          tasaAnual,
          plazoMeses,
          tipoAmortizacion,
        );

      default:
        throw Exception('Tipo de interés no soportado');
    }
  }

  List<Cuota> _calcularCuotasSimple(
      double monto, double tasaAnual, int plazoMeses) {
    // Implementación de cuotas con interés simple
    List<Cuota> cuotas = [];
    double interesMensual = tasaAnual / 12 / 100;
    double cuotaMensual = monto *
        interesMensual /
        (1 - pow(1 + interesMensual, -plazoMeses)); // Uso de pow

    for (int i = 1; i <= plazoMeses; i++) {
      cuotas.add(Cuota(
        numero: i,
        monto: cuotaMensual,
        capital: monto / plazoMeses,
        interes: cuotaMensual - monto / plazoMeses,
        fechaVencimiento:
            Timestamp.fromDate(DateTime.now().add(Duration(days: 30 * i))),
        estado: 'pendiente',
      ));
    }

    return cuotas;
  }

  List<Cuota> _calcularCuotasCompuesto(
      double monto, double tasaAnual, int plazoMeses) {
    // Implementación de cuotas con interés compuesto
    List<Cuota> cuotas = [];
    double interesMensual = tasaAnual / 12 / 100;
    double cuotaMensual = monto *
        interesMensual /
        (1 - pow(1 + interesMensual, -plazoMeses)); // Uso de pow

    for (int i = 1; i <= plazoMeses; i++) {
      cuotas.add(Cuota(
        numero: i,
        monto: cuotaMensual,
        capital: cuotaMensual - monto * interesMensual,
        interes: monto * interesMensual,
        fechaVencimiento:
            Timestamp.fromDate(DateTime.now().add(Duration(days: 30 * i))),
        estado: 'pendiente',
      ));
    }

    return cuotas;
  }

  List<Cuota> _calcularCuotasGradiente({
    required double primerPago,
    required double tasaInteres,
    required int periodos,
    required double gradienteOrTasaCrecimiento,
    required String tipoGradiente,
  }) {
    final tasaMensual = tasaInteres / 12 / 100;
    final cuotas = <Cuota>[];
    final fechaBase = DateTime.now();
    double saldo = primerPago;

    for (int i = 1; i <= periodos; i++) {
      double pago;

      if (tipoGradiente.toLowerCase() == 'aritmético') {
        // Aritmético: A + (i - 1) * G
        pago = primerPago + (i - 1) * gradienteOrTasaCrecimiento;
      } else {
        // Geométrico: A * (1 + g)^(i - 1)
        final tasaCrecimiento = gradienteOrTasaCrecimiento / 100;
        pago = primerPago * pow(1 + tasaCrecimiento, i - 1);
      }

      final interes = saldo * tasaMensual;
      final capital = pago - interes;
      saldo -= capital;

      cuotas.add(Cuota(
        numero: i,
        monto: pago,
        capital: capital,
        interes: interes,
        fechaVencimiento:
            Timestamp.fromDate(fechaBase.add(Duration(days: 30 * i))),
        estado: 'pendiente',
      ));
    }

    return cuotas;
  }

  List<Cuota> _calcularCuotasAmortizacion(
    double monto,
    double tasaAnual,
    int plazoMeses,
    String tipoAmortizacion,
  ) {
    final tasaMensual = tasaAnual / 12 / 100;
    final fechaBase = DateTime.now();
    final cuotas = <Cuota>[];

    switch (tipoAmortizacion.toLowerCase()) {
      case 'francés':
        final cuotaFija =
            monto * tasaMensual / (1 - pow(1 + tasaMensual, -plazoMeses));
        double saldo = monto;

        for (int i = 1; i <= plazoMeses; i++) {
          final interes = saldo * tasaMensual;
          final capital = cuotaFija - interes;
          saldo -= capital;

          cuotas.add(Cuota(
            numero: i,
            monto: cuotaFija,
            capital: capital,
            interes: interes,
            fechaVencimiento:
                Timestamp.fromDate(fechaBase.add(Duration(days: 30 * i))),
            estado: 'pendiente',
          ));
        }
        break;

      case 'alemán':
        final capitalFijo = monto / plazoMeses;
        double saldo = monto;

        for (int i = 1; i <= plazoMeses; i++) {
          final interes = saldo * tasaMensual;
          final cuota = capitalFijo + interes;
          saldo -= capitalFijo;

          cuotas.add(Cuota(
            numero: i,
            monto: cuota,
            capital: capitalFijo,
            interes: interes,
            fechaVencimiento:
                Timestamp.fromDate(fechaBase.add(Duration(days: 30 * i))),
            estado: 'pendiente',
          ));
        }
        break;

      case 'americano':
        for (int i = 1; i <= plazoMeses; i++) {
          final interes = monto * tasaMensual;
          final capital = (i == plazoMeses) ? monto : 0.0;
          final cuota = interes + capital;

          cuotas.add(Cuota(
            numero: i,
            monto: cuota,
            capital: capital,
            interes: interes,
            fechaVencimiento:
                Timestamp.fromDate(fechaBase.add(Duration(days: 30 * i))),
            estado: 'pendiente',
          ));
        }
        break;

      default:
        throw Exception('Tipo de amortización no soportado');
    }

    return cuotas;
  }

  Future<List<Transferencia>> obtenerTransferenciasEnviadas() async {
    return await _authService.obtenerTransferenciasEnviadas();
  }

  Future<List<Transferencia>> obtenerTransferenciasRecibidas() async {
    return await _authService.obtenerTransferenciasRecibidas();
  }

  // Realizar una transferencia
  Future<void> transferirDinero({
    required String remitenteNombre,
    required String remitenteCelular,
    required String remitenteCedula,
    required String destinatarioNombre,
    required String destinatarioCelular,
    required String destinatarioCedula,
    required double monto,
  }) async {
    try {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      // Obtener el documento del remitente (usuario actual)
      final remitenteSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();

      if (!remitenteSnapshot.exists) {
        throw Exception('No se encontró el remitente');
      }

      final remitenteData = remitenteSnapshot.data();
      final saldoRemitente = remitenteData?['Saldo'] as double?;

      if (saldoRemitente == null || saldoRemitente < monto) {
        throw Exception('Saldo insuficiente');
      }

      // Obtener el documento del destinatario
      final destinatarioSnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('Numero Documento', isEqualTo: destinatarioCedula)
          .limit(1)
          .get();

      if (destinatarioSnapshot.docs.isEmpty) {
        throw Exception('No se encontró el destinatario');
      }

      final destinatarioDoc = destinatarioSnapshot.docs.first;
      final destinatarioData = destinatarioDoc.data();
      final saldoDestinatario = destinatarioData['Saldo'] as double;

      // Crear el objeto Transferencia
      final transferencia = Transferencia(
        remitenteNombre: remitenteNombre,
        remitenteCelular: remitenteCelular,
        remitenteCedula: remitenteCedula,
        destinatarioNombre: destinatarioNombre,
        destinatarioCelular: destinatarioCelular,
        destinatarioCedula: destinatarioCedula,
        monto: monto,
        fechaHora: DateTime.now(),
        userId: user.uid,
      );

      // Guardar la transferencia en Firestore
      await FirebaseFirestore.instance
          .collection('transferencias')
          .add(transferencia.toMap());

      // Actualizar saldos en una transacción
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Disminuir saldo del remitente
        transaction.update(remitenteSnapshot.reference, {
          'Saldo': saldoRemitente - monto,
        });

        // Aumentar saldo del destinatario
        transaction.update(destinatarioDoc.reference, {
          'Saldo': saldoDestinatario + monto,
        });
      });

      print("Transferencia exitosa");
    } catch (e) {
      print("Error en AuthController (transferirDinero): $e");
      rethrow;
    }
  }

  // Método para obtener el nombre del usuario desde Firestore
  Future<Map<String, dynamic>> getUserData(String uid) async {
    try {
      final userDoc = await _firestore.collection('usuarios').doc(uid).get();
      print(
          "Datos del usuario desde Firestore: ${userDoc.data()}"); // Depuración
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
      throw Exception('Usuario no encontrado');
    } catch (e) {
      print("Error al obtener los datos del usuario: $e");
      rethrow;
    }
  }

  // Método para acceder al servicio de autenticación biométrica
  BiometricAuthService get biometricAuthService => _biometricAuthService;

  // Guardar el estado de autenticación
  Future<void> _saveAuthState(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  // Obtener el estado de autenticación
  Future<String?> getAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // Guardar el número de documento en SharedPreferences
  Future<void> _saveDocumentNumber(String numeroDocumento) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('documentNumber', numeroDocumento);
  }

  // Obtener el número de documento guardado
  Future<String?> _getSavedDocumentNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('documentNumber');
  }

  // Registrar usuario con encriptación
  Future<bool> registrarUsuario(
      String nombre,
      String tipoDocumento,
      String numeroDocumento,
      String telefono,
      String email,
      String contrasena) async {
    try {
      // Crear el objeto User con la contraseña encriptada
      User usuario = User(
        nombre: nombre,
        tipoDocumento: tipoDocumento,
        numeroDocumento: numeroDocumento,
        telefono: telefono,
        email: email,
      );

      // Registrar el usuario en Firebase
      final firebaseUser =
          await _authService.registrarUsuario(usuario, contrasena);
      if (firebaseUser != null) {
        await _saveDocumentNumber(
            numeroDocumento); // Guardar el número de documento
        return true;
      }
      return false;
    } catch (e) {
      print("Error en AuthController (registrarUsuario): $e");
      return false;
    }
  }

  // Iniciar sesión con autenticación biométrica y encriptación
  Future<bool> iniciarSesion(String numeroDocumento, String contrasena) async {
    try {
      // Iniciar sesión en Firebase (o tu backend)
      final firebaseUser =
          await _authService.iniciarSesion(numeroDocumento, contrasena);
      if (firebaseUser != null) {
        await _saveAuthState(firebaseUser.uid); // Guardar el UID
        print("UID del usuario: ${firebaseUser.uid}"); //Depuracion
        await _saveDocumentNumber(
            numeroDocumento); // Guardar el número de documento
        return true;
      }
      return false;
    } catch (e) {
      print("Error en AuthController (iniciarSesion): $e");
      return false;
    }
  }

  // Verificar si el usuario ya ha iniciado sesión
  Future<bool> isUserLoggedIn() async {
    final savedUserId = await getAuthState();
    return savedUserId != null;
  }

  // Verificar si el usuario está registrado (tiene un número de documento guardado)
  Future<bool> isUserRegistered() async {
    final savedDocumentNumber = await _getSavedDocumentNumber();
    return savedDocumentNumber != null;
  }

  // Obtener el número de documento guardado
  Future<String?> getSavedDocumentNumber() async {
    return await _getSavedDocumentNumber();
  }

  // Autenticar con biométricos (solo si el usuario ya ha iniciado sesión)
  Future<bool> authenticateWithBiometrics() async {
    try {
      final didAuthenticate = await _biometricAuthService.authenticate();
      return didAuthenticate;
    } catch (e) {
      print("Error en AuthController (authenticateWithBiometrics): $e");
      return false;
    }
  }
}
