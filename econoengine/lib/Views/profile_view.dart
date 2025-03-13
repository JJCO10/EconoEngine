import 'package:econoengine/Views/Auth/forgot_password_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String nombre = "";
  String tipoDocumento = "";
  String numeroDocumento = "";
  String email = "";
  String telefono = "";

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("Usuario no autenticado");

      final docUser = await _firestore.collection('usuarios').doc(user.uid).get();
      if (docUser.exists) {
        final data = docUser.data()!;
        setState(() {
          nombre = data['Nombre'] ?? "";
          tipoDocumento = data['Tipo Documento'] ?? "";
          numeroDocumento = data['Numero Documento'] ?? "";
          email = data['Email'] ?? "";
          telefono = data['Telefono'] ?? "";
          _isLoading = false;
        });
      } else {
        throw Exception("No se encontraron datos del usuario");
      }
    } catch (e) {
      print("Error al cargar usuario: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _guardarCambios() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("Usuario no autenticado");

      await _firestore.collection('usuarios').doc(user.uid).update({
        'Email': email,
        'Telefono': telefono,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Perfil actualizado exitosamente")),
      );
    } catch (e) {
      print("Error al actualizar perfil: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar perfil")),
      );
    }
  }

  void _cambiarContrasena() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Editar Perfil")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Formulario
                    Container(
                      width: 350, // Ancho fijo para centrar en pantallas grandes
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          if (!isDarkMode)
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildTextField("Nombre", nombre, false, isDarkMode),
                          SizedBox(height: 10),
                          _buildTextField("Tipo de Documento", tipoDocumento, false, isDarkMode),
                          SizedBox(height: 10),
                          _buildTextField("Número de Documento", numeroDocumento, false, isDarkMode),
                          SizedBox(height: 10),
                          _buildTextField("Email", email, true, isDarkMode, (value) => email = value),
                          SizedBox(height: 10),
                          _buildTextField("Teléfono", telefono, true, isDarkMode, (value) => telefono = value),
                          SizedBox(height: 20),

                            // Botón Guardar Cambios centrado
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                onPressed: _guardarCambios,
                                // style: ElevatedButton.styleFrom(
                                //   backgroundColor: isDarkMode ? Colors.lightBlueAccent : Colors.blue,
                                // ),
                                child: Text(
                                  "Guardar Cambios",
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.lightBlueAccent : Colors.blue,
                                    fontSize: 16,
                                  ),
                                  ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 50), // Espacio entre el formulario y el botón

                  // Botón Cambiar Contraseña (ahora afuera del formulario)
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: _cambiarContrasena,
                      child: Text(
                        "Deseas cambiar tu contraseña",
                        style: TextStyle(
                          color: isDarkMode ? Colors.lightBlueAccent : Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            ),
    );
  }

  /// Widget reutilizable para los campos de texto
  Widget _buildTextField(String label, String value, bool isEditable, bool isDarkMode, [Function(String)? onChanged]) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDarkMode ? Colors.white54 : Colors.black38),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDarkMode ? Colors.lightBlueAccent : Colors.blue),
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      // textAlign: TextAlign.center,
      enabled: isEditable,
      onChanged: isEditable ? onChanged : null,
    );
  } 
}
