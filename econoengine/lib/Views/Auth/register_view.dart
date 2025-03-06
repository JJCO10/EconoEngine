import 'package:flutter/material.dart';
import 'package:econoengine/controllers/auth_controller.dart'; // Importa el controlador de autenticación
import 'login_view.dart'; // Importa la vista de inicio de sesión

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _tipoDocumentoController = TextEditingController();
  final TextEditingController _numeroDocumentoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmcontrasenaController = TextEditingController();

  final AuthController _authController = AuthController(); // Controlador de autenticación

  String _errorMessage = '';

  @override
  void dispose() {
    _nombreController.dispose();
    _tipoDocumentoController.dispose();
    _numeroDocumentoController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _contrasenaController.dispose();
    _confirmcontrasenaController.dispose();
    super.dispose();
  }

  Future<void> _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      final nombre = _nombreController.text.trim();
      final tipoDocumento = _tipoDocumentoController.text.trim();
      final numeroDocumento = _numeroDocumentoController.text.trim();
      final telefono = _telefonoController.text.trim();
      final email = _emailController.text.trim();
      final contrasena = _contrasenaController.text.trim();

      try {
        final success = await _authController.registrarUsuario(
          nombre,
          tipoDocumento,
          numeroDocumento,
          telefono,
          email,
          contrasena,
        );

        if (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        } else {
          setState(() {
            _errorMessage = 'Error al registrar usuario. Inténtalo de nuevo.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error: $e';
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
                const SizedBox(height: 60),
                Image.asset('assets/images/logo.png', height: 100),
                const SizedBox(height: 30),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red[700], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                _buildTextField(_nombreController, 'Nombre completo', Icons.person),
                _buildTextField(_tipoDocumentoController, 'Tipo de Documento', Icons.credit_card),
                _buildTextField(_numeroDocumentoController, 'Número de Documento', Icons.numbers),
                _buildTextField(_telefonoController, 'Teléfono', Icons.phone),
                _buildEmailField(),
                _buildPasswordField(_contrasenaController, 'Contraseña', Icons.lock),
                _buildConfirmPasswordField(),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _registrarUsuario,
                  child: const Text(
                    'Crear cuenta',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginView()),
                    );
                  },
                  child: Text(
                    '¿Ya tienes una cuenta? Inicia sesión',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value!.isEmpty) return 'Por favor ingresa $label';
          return null;
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: 'Correo electrónico',
          prefixIcon: const Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Ingresa un correo válido';
          final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
          if (!emailRegex.hasMatch(value)) return 'Formato de correo inválido';
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Por favor ingresa tu contraseña';
          if (value.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
          return null;
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: _confirmcontrasenaController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Confirmar contraseña',
          prefixIcon: const Icon(Icons.lock_reset),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Confirma tu contraseña';
          if (value != _contrasenaController.text) return 'Las contraseñas no coinciden';
          return null;
        },
      ),
    );
  }
}
