import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

import '../services/auth_service.dart';
import '../services/biometric_auth_service.dart'; // Servicio de autenticación biométrica
import '../models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BiometricAuthService _biometricAuthService = BiometricAuthService();

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