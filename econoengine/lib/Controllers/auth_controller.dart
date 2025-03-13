import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econoengine/Models/transferencia.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/biometric_auth_service.dart';
import '../models/users.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BiometricAuthService _biometricAuthService = BiometricAuthService();

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
      await FirebaseFirestore.instance.collection('transferencias').add(transferencia.toMap());

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

  // Método para realizar transferencias
  // Future<void> transferirDinero(String telefonoDestinatario, double monto, {required String remitenteCelular, required String remitenteNombre}) async {
  //   try {
  //     // Obtener el usuario actual
  //     final user = firebase_auth.FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       throw Exception('Usuario no autenticado');
  //     }

  //     // Obtener el documento del remitente (usuario actual)
  //     final remitenteSnapshot = await _firestore.collection('usuarios').doc(user.uid).get();
  //     if (!remitenteSnapshot.exists) {
  //       throw Exception('No se encontró el remitente');
  //     }

  //     final remitenteData = remitenteSnapshot.data();
  //     final telefonoRemitente = remitenteData?['Telefono'] as String?;
  //     final saldoRemitente = remitenteData?['Saldo'] as double?;

  //     if (telefonoRemitente == null || saldoRemitente == null) {
  //       throw Exception('Datos del remitente incompletos');
  //     }

  //     if (saldoRemitente < monto) {
  //       throw Exception('Saldo insuficiente');
  //     }

  //     // Obtener el documento del destinatario
  //     final destinatarioSnapshot = await _firestore
  //         .collection('usuarios')
  //         .where('Telefono', isEqualTo: telefonoDestinatario)
  //         .limit(1)
  //         .get();

  //     if (destinatarioSnapshot.docs.isEmpty) {
  //       throw Exception('No se encontró el destinatario');
  //     }

  //     final destinatarioDoc = destinatarioSnapshot.docs.first;
  //     final destinatarioData = destinatarioDoc.data();
  //     final saldoDestinatario = destinatarioData['Saldo'] as double;

  //     // Actualizar saldos en una transacción
  //     await _firestore.runTransaction((transaction) async {
  //       // Disminuir saldo del remitente
  //       transaction.update(remitenteSnapshot.reference, {
  //         'Saldo': saldoRemitente - monto,
  //       });

  //       // Aumentar saldo del destinatario
  //       transaction.update(destinatarioDoc.reference, {
  //         'Saldo': saldoDestinatario + monto,
  //       });
  //     });

  //     print("Transferencia exitosa");
  //   } catch (e) {
  //     print("Error en AuthController (transferirDinero): $e");
  //     rethrow;
  //   }
  // }


  // Método para obtener el nombre del usuario desde Firestore
  Future<Map<String, dynamic>> getUserData(String uid) async {
    try {
      final userDoc = await _firestore.collection('usuarios').doc(uid).get();
      print("Datos del usuario desde Firestore: ${userDoc.data()}"); // Depuración
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
  Future<bool> registrarUsuario(String nombre, String tipoDocumento, String numeroDocumento, String telefono, String email, String contrasena) async {
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
      final firebaseUser = await _authService.registrarUsuario(usuario, contrasena);
      if (firebaseUser != null) {
        await _saveDocumentNumber(numeroDocumento); // Guardar el número de documento
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
      final firebaseUser = await _authService.iniciarSesion(numeroDocumento, contrasena);
      if (firebaseUser != null) {
        await _saveAuthState(firebaseUser.uid); // Guardar el UID
        print("UID del usuario: ${firebaseUser.uid}"); //Depuracion
        await _saveDocumentNumber(numeroDocumento); // Guardar el número de documento
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