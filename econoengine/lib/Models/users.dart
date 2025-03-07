// models/users.dart
class User {
  final String nombre;
  final String tipoDocumento;
  final String numeroDocumento;
  final String telefono;
  final String email; // Añade este campo
  final String contrasena;

  User({
    required this.nombre,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.telefono,
    required this.email, // Añade este parámetro
    required this.contrasena,
  });
}