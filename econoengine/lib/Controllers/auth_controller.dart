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
        final didAuthenticate = await _biometricAuthService.authenticate();
        if (!didAuthenticate) {
          throw Exception('Autenticación biométrica fallida');
        }
      }

      // Encriptar la contraseña antes de enviarla
      // final encryptedPassword = EncryptionService.encrypt(contrasena);

      // Iniciar sesión en Firebase
      final firebaseUser = await _authService.iniciarSesion(numeroDocumento, contrasena);
      return firebaseUser != null;
      // if (firebaseUser != null) {
      //   // Almacenar el UID del usuario de manera segura
      //   await _secureStorageService.write('userUid', firebaseUser.uid);
      //   return true;
      // }
      // return false;
    } catch (e) {
      print("Error en AuthController (iniciarSesion): $e");
      return false;
    }
  }
}