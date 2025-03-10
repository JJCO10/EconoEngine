import 'package:econoengine/Views/Auth/forgot_password_view.dart';
import 'package:flutter/material.dart';
import 'package:econoengine/controllers/auth_controller.dart'; // Importa el controlador de autenticación
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
  final AuthController _authController = AuthController();
  String _errorMessage = '';
  bool _isUserLoggedIn = false;
  String _savedDocumentNumber = '';

  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
  }

  // Verificar si el usuario ya ha iniciado sesión
  Future<void> _checkIfUserIsLoggedIn() async {
    final isLoggedIn = await _authController.isUserLoggedIn();
    if (isLoggedIn) {
      final savedDocumentNumber = await _authController.getSavedDocumentNumber();
      _savedDocumentNumber = savedDocumentNumber ?? ''; // Guardar el número real
      _numeroDocumentoController.text = _maskDocumentNumber(savedDocumentNumber ?? '');
    }
    setState(() {
      _isUserLoggedIn = isLoggedIn;
    });
  }

  // Método para iniciar sesión con credenciales
  Future<void> _iniciarSesion() async {
    if (_formKey.currentState!.validate()) {
      final password = _passwordController.text.trim();

      try {
        // Usar el número de documento real guardado en _savedDocumentNumber
        final success = await _authController.iniciarSesion(_savedDocumentNumber, password);
        if (success) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          setState(() {
            _errorMessage = 'Contraseña incorrecta.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error al iniciar sesión: $e';
        });
      }
    }
  }

  // Ocultar los dígitos excepto los últimos 4
  String _maskDocumentNumber(String documentNumber) {
    if (documentNumber.length <= 4) {
      return documentNumber; // Si tiene 4 o menos caracteres, no ocultamos nada.
    }
    // Ocultamos todos los caracteres excepto los últimos 4.
    final maskedPart = '*' * (documentNumber.length - 4);
    final lastFourDigits = documentNumber.substring(documentNumber.length - 4);
    return maskedPart + lastFourDigits;
  }

  // Método para iniciar sesión con autenticación biométrica
  Future<void> _iniciarSesionBiometrico() async {
    try {
      final didAuthenticate = await _authController.authenticateWithBiometrics();
      if (didAuthenticate) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _errorMessage = 'Autenticación biométrica fallida.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error en la autenticación biométrica: $e';
      });
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
                  readOnly: _isUserLoggedIn, // Deshabilitar edición si el usuario ya ha iniciado sesión
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
                if (_isUserLoggedIn)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _iniciarSesionBiometrico,
                    child: const Text(
                      'Iniciar sesión con huella',
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