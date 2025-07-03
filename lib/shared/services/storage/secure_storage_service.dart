import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  SecureStorageService() : _secureStorage = const FlutterSecureStorage();

  static const _keyAccessToken = 'ACCESS_TOKEN';
  static const _keyRefreshToken = 'REFRESH_TOKEN';

  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _keyAccessToken, value: token);
  }

  Future<String?> readAccessToken() async {
    return await _secureStorage.read(key: _keyAccessToken);
  }

  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: _keyAccessToken);
  }

  // Similar for refresh token
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _keyRefreshToken, value: token);
  }

  Future<String?> readRefreshToken() async {
    return await _secureStorage.read(key: _keyRefreshToken);
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }
}
