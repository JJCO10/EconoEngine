import 'package:econoengine/Views/Auth/forgot_password_view.dart';
import 'package:flutter/material.dart';
import 'package:econoengine/Controllers/auth_controller.dart'; // Importa el controlador de autenticación
import 'register_view.dart'; // Importa la vista de registro
import 'package:econoengine/l10n/app_localizations_setup.dart'; // Asegúrate de importar AppLocalizations

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numeroDocumentoController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  String _errorMessage = '';
  bool _isUserLoggedIn = false;
  String _savedDocumentNumber = '';
  bool _showBiometricButton = false;

  @override
  void initState() {
    super.initState();
    _checkIfUserIsLoggedIn();
    _checkBiometricSupport(); // Verificar soporte biométrico al iniciar
  }

  // Verificar si el usuario ya ha iniciado sesión
  Future<void> _checkIfUserIsLoggedIn() async {
    final isLoggedIn = await _authController.isUserLoggedIn();
    if (isLoggedIn) {
      final savedDocumentNumber =
          await _authController.getSavedDocumentNumber();
      if (savedDocumentNumber != null) {
        _savedDocumentNumber = savedDocumentNumber; // Guardar el número real
        _numeroDocumentoController.text =
            _maskDocumentNumber(savedDocumentNumber); // Mostrar enmascarado
      }
    }
    setState(() {
      _isUserLoggedIn = isLoggedIn;
    });
  }

  // Verificar si el dispositivo soporta autenticación biométrica y tiene configurada la huella
  Future<void> _checkBiometricSupport() async {
    final canAuthenticate =
        await _authController.biometricAuthService.canAuthenticate();
    final hasBiometricSetup =
        await _authController.biometricAuthService.hasBiometricSetup();
    setState(() {
      _showBiometricButton = canAuthenticate && hasBiometricSetup;
    });
  }

  // Método para iniciar sesión con credenciales
  Future<void> _iniciarSesion() async {
    if (_formKey.currentState!.validate()) {
      final password = _passwordController.text.trim();
      // Si el usuario estaba logueado, usar el número real guardado
      final numeroDocumento = _isUserLoggedIn
          ? _savedDocumentNumber
          : _numeroDocumentoController.text.trim();

      try {
        // Usar el número de documento real guardado en _savedDocumentNumber
        final success =
            await _authController.iniciarSesion(numeroDocumento, password);
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
      final didAuthenticate =
          await _authController.authenticateWithBiometrics();
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
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context); // Shortcut para las traducciones

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: loc.documentNumber,
                    labelStyle: TextStyle(
                      color: isDarkmode ? Colors.white70 : Colors.black87,
                    ),
                    prefixIcon: Icon(Icons.person_outline,
                        color: isDarkmode ? Colors.white70 : Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: isDarkmode ? Colors.white70 : Colors.black54),
                    ),
                  ),
                  readOnly: _isUserLoggedIn,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return loc.pleaseEnterDocument;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: loc.password,
                    labelStyle: TextStyle(
                      color: isDarkmode ? Colors.white70 : Colors.black87,
                    ),
                    prefixIcon: Icon(Icons.lock_outline,
                        color: isDarkmode ? Colors.white70 : Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: isDarkmode ? Colors.white70 : Colors.black54),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return loc.pleaseEnterPassword;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _iniciarSesion,
                  child: Text(
                    loc.login,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                if (_isUserLoggedIn && _showBiometricButton)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _iniciarSesionBiometrico,
                    child: Text(
                      loc.loginWithFingerprint,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordView(),
                      ),
                    );
                  },
                  child: Text(
                    loc.forgotPassword,
                    style: TextStyle(
                        color: isDarkmode ? Colors.white70 : Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(loc.dontHaveAccount,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface)),
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
                        loc.register,
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
