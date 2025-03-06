import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/users.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Registrar usuario
  Future<firebase_auth.User?> registrarUsuario(User usuario) async {
    try {
      // Registrar usuario en Firebase Auth
      firebase_auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: usuario.email, // Usar el email proporcionado por el usuario
        password: usuario.contrasena,
      );

      // Guardar datos adicionales en Firestore
      await _firestore.collection('usuarios').doc(userCredential.user?.uid).set({
        'nombre': usuario.nombre,
        'tipoDocumento': usuario.tipoDocumento,
        'numeroDocumento': usuario.numeroDocumento,
        'telefono': usuario.telefono,
        'email': usuario.email, // Guardar el email en Firestore
      });

      return userCredential.user; // Retornar el User de Firebase
    } catch (e) {
      print("Error al registrar usuario: $e");
      return null;
    }
  }

  // Iniciar sesión
  Future<firebase_auth.User?> iniciarSesion(String email, String contrasena) async {
    try {
      // Iniciar sesión en Firebase Auth
      firebase_auth.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, // Usar el email proporcionado por el usuario
        password: contrasena,
      );

      return userCredential.user; // Retornar el User de Firebase
    } catch (e) {
      print("Error al iniciar sesión: $e");
      return null;
    }
  }
}