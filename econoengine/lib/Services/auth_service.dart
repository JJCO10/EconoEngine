import 'package:econoengine/Models/transferencia.dart';
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

  // Guardar una transferencia en Firestore
  Future<void> guardarTransferencia(Transferencia transferencia) async {
    try {
      await _firestore.collection('transferencias').add(transferencia.toMap());
    } catch (e) {
      print("Error al guardar transferencia: $e");
      rethrow;
    }
  }

  // Obtener transferencias enviadas por el usuario actual
  Future<List<Transferencia>> obtenerTransferenciasEnviadas() async {
    try {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      final querySnapshot = await _firestore
          .collection('transferencias')
          .where('userId', isEqualTo: user.uid)
          .orderBy('fechaHora', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Transferencia.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error al obtener transferencias enviadas: $e");
      return [];
    }
  }

  // Obtener transferencias recibidas por el usuario actual
  Future<List<Transferencia>> obtenerTransferenciasRecibidas() async {
    try {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      final querySnapshot = await _firestore
          .collection('transferencias')
          .where('destinatarioCedula', isEqualTo: user.uid)
          .orderBy('fechaHora', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Transferencia.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error al obtener transferencias recibidas: $e");
      return [];
    }
  }
}