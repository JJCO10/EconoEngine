import 'package:econoengine/Views/Auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:econoengine/Controllers/auth_controller.dart';
import 'package:econoengine/l10n/app_localizations_setup.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _numeroDocumentoController =
      TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmcontrasenaController =
      TextEditingController();

  final AuthController _authController = AuthController();
  String _errorMessage = '';
  String? _selectedDocumentType;
  final List<String> _documentTypes = ['CC', 'TI', 'CE', 'PP'];

  @override
  void dispose() {
    _nombreController.dispose();
    _numeroDocumentoController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _contrasenaController.dispose();
    _confirmcontrasenaController.dispose();
    super.dispose();
  }

  Future<void> _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      final loc = AppLocalizations.of(context);
      final nombre = _nombreController.text.trim();
      final tipoDocumento = _selectedDocumentType ?? '';
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
            _errorMessage = loc.registerError;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = '${loc.loginError}: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

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
                Image.asset('assets/images/logo.png', height: 100),
                const SizedBox(height: 20),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red[700], fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                _buildTextField(
                    context, _nombreController, loc.fullName, Icons.person),
                _buildDocumentTypeField(context, loc),
                _buildTextField(
                    context, _telefonoController, loc.phone, Icons.phone),
                _buildEmailField(context, loc),
                _buildPasswordField(context, _contrasenaController,
                    loc.password, Icons.lock, loc),
                _buildConfirmPasswordField(context, loc),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _registrarUsuario,
                  child: Text(
                    loc.createAccount,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()),
                    );
                  },
                  child: Text(
                    loc.alreadyHaveAccount,
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

  Widget _buildTextField(
    BuildContext context,
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    final loc = AppLocalizations.of(context);
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
          if (value!.isEmpty) {
            return '${loc.pleaseEnter} $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDocumentTypeField(BuildContext context, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: _selectedDocumentType,
              decoration: InputDecoration(
                labelText: loc.documentType,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: _documentTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDocumentType = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return loc.selectDocumentType;
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: _numeroDocumentoController,
              decoration: InputDecoration(
                labelText: loc.documentNumber,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return loc.enterDocumentNumber;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField(BuildContext context, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          labelText: loc.email,
          prefixIcon: const Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return loc.enterValidEmail;
          }
          final emailRegex =
              RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
          if (!emailRegex.hasMatch(value)) {
            return loc.invalidEmailFormat;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(
    BuildContext context,
    TextEditingController controller,
    String label,
    IconData icon,
    AppLocalizations loc,
  ) {
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
          if (value == null || value.isEmpty) {
            return loc.enterPassword;
          }
          if (value.length < 6) {
            return loc.passwordLength;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField(
      BuildContext context, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: TextFormField(
        controller: _confirmcontrasenaController,
        obscureText: true,
        decoration: InputDecoration(
          labelText: loc.confirmPassword,
          prefixIcon: const Icon(Icons.lock_reset),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return loc.confirmYourPassword;
          }
          if (value != _contrasenaController.text) {
            return loc.passwordsDontMatch;
          }
          return null;
        },
      ),
    );
  }
}
