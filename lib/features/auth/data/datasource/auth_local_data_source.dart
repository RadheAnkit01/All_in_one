import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_session.dart';

class AuthLocalDataSource {
  AuthLocalDataSource({required this._tokenStorage});

  final TokenStorage _tokenStorage;

  Future<void> saveSession(AuthSession session) {
    return _tokenStorage.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
  }

  Future<String?> getAccessToken() {
    return _tokenStorage.getAccessToken();
  }

  Future<String?> getRefreshToken() {
    return _tokenStorage.getRefreshToken();
  }

  Future<void> clearSession() {
    return _tokenStorage.clearTokens();
  }
}
