// controllers/auth_controller.dart
import '../services/auth_service.dart';
import '../models/users.dart';

class AuthController {
  final AuthService _authService = AuthService();

  // Registrar usuario
  Future<bool> registrarUsuario(String nombre, String tipoDocumento, String numeroDocumento, String telefono, String email, String contrasena) async {
    User usuario = User(
      nombre: nombre,
      tipoDocumento: tipoDocumento,
      numeroDocumento: numeroDocumento,
      telefono: telefono,
      email: email, // Asegúrate de pasar el email
      contrasena: contrasena,
    );

    // Llamar al servicio y obtener el User de Firebase
    final firebaseUser = await _authService.registrarUsuario(usuario);
    return firebaseUser != null; // Retornar true si el usuario se registró correctamente
  }

  // Iniciar sesión
  Future<bool> iniciarSesion(String numeroDocumento, String contrasena) async {
    // Llamar al servicio y obtener el User de Firebase
    final firebaseUser = await _authService.iniciarSesion(numeroDocumento, contrasena);
    return firebaseUser != null; // Retornar true si el inicio de sesión fue exitoso
  }
}