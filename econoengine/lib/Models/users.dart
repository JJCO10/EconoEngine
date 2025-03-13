class User {
  final String nombre;
  final String tipoDocumento;
  final String numeroDocumento;
  final String telefono;
  final String email;
  final double saldo;

  User({
    required this.nombre,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.telefono,
    required this.email,
    this.saldo = 0.0,
  });
}