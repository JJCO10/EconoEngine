import 'dart:math';

import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final key = Key.fromUtf8('your-32-character-encryption-key'); // Clave de 32 caracteres
  // static final iv = IV.fromUtf8('16-char-iv-value'); // IV de 16 caracteres
  // static final iv = IV.fromUtf8('abcdefghijklmnop');

  // Generar un IV de 16 caracteres dinámicamente
  static final iv = IV.fromUtf8(_generateIV());

  // Función para generar un IV de 16 caracteres
  static String _generateIV() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return String.fromCharCodes(
      List.generate(16, (index) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }
  
  // Encriptar un texto
  static String encrypt(String plainText) {
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  // Desencriptar un texto
  static String decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}