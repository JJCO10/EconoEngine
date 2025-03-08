import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  // Almacenar un valor
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Recuperar un valor
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Eliminar un valor
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}