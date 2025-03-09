import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Verificar si el dispositivo soporta autenticación biométrica
  Future<bool> canAuthenticate() async {
    final bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();
    return canAuthenticate;
  }

  // Verificar si el usuario tiene configurado un bloqueo biométrico
  Future<bool> hasBiometricSetup() async {
    try {
      final List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e) {
      throw Exception('Error al verificar la configuración biométrica: $e');
    }
  }

  // Autenticar al usuario
  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Por favor autentícate para iniciar sesión',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      return didAuthenticate;
    } catch (e) {
      throw Exception('Error en la autenticación biométrica: $e');
    }
  }
}