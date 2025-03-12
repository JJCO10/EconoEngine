import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/users.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Registrar usuario
  Future<firebase_auth.User?> registrarUsuario(User usuario, String contrasena) async {
    try {
      // Registrar usuario en Firebase Auth
      firebase_auth.UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: usuario.email, // Usar el email proporcionado por el usuario
        password: contrasena,
      );

      // Guardar datos adicionales en Firestore
      await _firestore.collection('usuarios').doc(userCredential.user?.uid).set({
        'Nombre': usuario.nombre,
        'Tipo Documento': usuario.tipoDocumento,
        'Numero Documento': usuario.numeroDocumento,
        'Telefono': usuario.telefono,
        'Email': usuario.email, // Guardar el email en Firestore
        'Saldo': 0.0,
      });

      return userCredential.user; // Retornar el User de Firebase
    } catch (e) {
      print("Error al registrar usuario: $e");
      return null;
    }
  }

  // Iniciar sesión
 // services/auth_service.dart
  Future<firebase_auth.User?> iniciarSesion(String numeroDocumento, String contrasena) async {
    try {
      // Buscar el correo electrónico asociado al número de documento en Firestore
      final querySnapshot = await _firestore
          .collection('usuarios')
          .where('Numero Documento', isEqualTo: numeroDocumento)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No se encontró un usuario con ese número de documento');
      }

      final userData = querySnapshot.docs.first.data();
      final email = userData['Email'] as String;

      // Iniciar sesión en Firebase Auth con el correo electrónico
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: contrasena,
      );

      return userCredential.user;
    } catch (e) {
      print("Error al iniciar sesión: $e");
      return null;
    }
  }
}