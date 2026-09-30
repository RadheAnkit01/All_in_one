import 'package:all_in_one/core/storage/secure_storage.dart';
import 'package:all_in_one/features/auth/domain/entities/auth_session.dart';

class AuthLocalDataSource {
  AuthLocalDataSource({required this._secureStorage});

  final SecureStorage _secureStorage;

  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';

  Future<void> saveSession(AuthSession session) async {
    await _secureStorage.write(
      key: _accessTokenKey,
      value: session.accessToken,
    );

    await _secureStorage.write(
      key: _refreshTokenKey,
      value: session.refreshToken,
    );
  }

  Future<String?> getAccessToken() {
    return _secureStorage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> clearSession() async {
    await _secureStorage.delete(key: _accessTokenKey);

    await _secureStorage.delete(key: _refreshTokenKey);
  }
}
