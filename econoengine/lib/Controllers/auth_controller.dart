import '../services/auth_service.dart';
import '../services/biometric_auth_service.dart'; // Servicio de autenticación biométrica
import '../models/users.dart';

class AuthController {
  final AuthService _authService = AuthService();
  final BiometricAuthService _biometricAuthService = BiometricAuthService();
  // final SecureStorageService _secureStorageService = SecureStorageService();

  // Registrar usuario con encriptación
  Future<bool> registrarUsuario(String nombre, String tipoDocumento, String numeroDocumento, String telefono, String email, String contrasena) async {
    try {
      // Encriptar la contraseña antes de enviarla
      // final encryptedPassword = EncryptionService.encrypt(contrasena);

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
      return firebaseUser != null;
    } catch (e) {
      print("Error en AuthController (registrarUsuario): $e");
      return false;
    }
  }

  // Iniciar sesión con autenticación biométrica y encriptación
  Future<bool> iniciarSesion(String numeroDocumento, String contrasena) async {
    try {
      // Verificar si el dispositivo soporta autenticación biométrica
      final canAuthenticate = await _biometricAuthService.canAuthenticate();
      if (canAuthenticate) {
        // Verificar si el usuario tiene configurado un bloqueo biométrico
        final hasBiometricSetup = await _biometricAuthService.hasBiometricSetup();
        if (hasBiometricSetup) {
          // Intentar autenticar al usuario biométricamente
          final didAuthenticate = await _biometricAuthService.authenticate();
          if (!didAuthenticate) {
            throw Exception('Autenticación biométrica fallida');
          }
        }
        // Si no tiene configurado un bloqueo biométrico, continuar con el inicio de sesión normal
      }

      // Iniciar sesión en Firebase (o tu backend)
      final firebaseUser = await _authService.iniciarSesion(numeroDocumento, contrasena);
      return firebaseUser != null;
    } catch (e) {
      print("Error en AuthController (iniciarSesion): $e");
      return false;
    }
  }
}