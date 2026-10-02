import 'secure_storage.dart';
import 'token_storage.dart';

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage({required this._secureStorage});

  final SecureStorage _secureStorage;

  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';

  @override
  Future<String?> getAccessToken() {
    return _secureStorage.read(key: _accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);

    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  @override
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);

    await _secureStorage.delete(key: _refreshTokenKey);
  }
}
