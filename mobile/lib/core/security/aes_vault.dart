import 'package:encrypt/encrypt.dart';

class AesVault {
  static final _key = Key.fromSecureRandom(32); // In a real app, this should be stored securely
  static final _iv = IV.fromSecureRandom(16);
  static final _encrypter = Encrypter(AES(_key));

  static String encrypt(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decrypt(String encryptedText) {
    final decrypted = _encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: _iv);
    return decrypted;
  }
}
