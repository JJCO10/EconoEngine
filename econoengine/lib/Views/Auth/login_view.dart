import 'package:econoengine/Views/Auth/forgot_password_view.dart';
import 'package:flutter/material.dart';
import 'package:econoengine/controllers/auth_controller.dart'; // Importa el controlador de autenticación
// import 'package:econoengine/services/biometric_auth_service.dart'; // Importa el servicio de autenticación biométrica
// import 'package:econoengine/services/encryption_service.dart'; // Importa el servicio de encriptación
import 'register_view.dart'; // Importa la vista de registro

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numeroDocumentoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Instancia del controlador de autenticación
  final AuthController _authController = AuthController();

  // Instancia del servicio de autenticación biométrica
  // final BiometricAuthService _biometricAuthService = BiometricAuthService();

  // Variable para mostrar errores
  String _errorMessage = '';

  // Método para iniciar sesión
  Future<void> _iniciarSesion() async {
    if (_formKey.currentState!.validate()) {
      final numeroDocumento = _numeroDocumentoController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // Llamar al controlador para iniciar sesión
        final success = await _authController.iniciarSesion(numeroDocumento, password);

        if (success) {
          // Navegar a la pantalla principal (cambia '/home' por tu ruta)
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() {
            _errorMessage = 'Número de documento o contraseña incorrectos.';
          });
        }
      } catch (e) {
        setState(() {
          // Mostrar un mensaje de error específico
          if (e.toString().contains('Autenticación biométrica fallida')) {
            _errorMessage = 'Autenticación biométrica fallida. Intenta nuevamente.';
          } else {
            _errorMessage = 'Error al iniciar sesión: $e';
          }
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 80),
                Image.asset('assets/images/logo.png', height: 100),
                const SizedBox(height: 40),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _numeroDocumentoController,
                  decoration: InputDecoration(
                    labelText: 'Número de Documento',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingresa tu número de documento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _iniciarSesion, // Llamar al método de inicio de sesión
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Lógica para recuperar contraseña
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordView(),
                      ),
                    );
                  },
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('¿No tienes cuenta? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterView(),
                          ),
                        );
                      },
                      child: Text(
                        'Regístrate',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}