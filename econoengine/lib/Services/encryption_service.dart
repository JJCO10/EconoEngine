import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final key = Key.fromUtf8('your-32-character-encryption-key'); // Clave de 32 caracteres
  static final iv = IV.fromUtf8('your-16-character-iv'); // IV de 16 caracteres

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