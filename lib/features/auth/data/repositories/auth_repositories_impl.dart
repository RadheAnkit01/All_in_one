import 'package:all_in_one/core/errors/app_failures.dart';
import 'package:all_in_one/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:all_in_one/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:all_in_one/features/auth/data/models/login_request_model.dart';
import 'package:all_in_one/features/auth/domain/entities/auth_session.dart';
import 'package:all_in_one/features/auth/domain/entities/user.dart';
import 'package:all_in_one/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter/cupertino.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this._remoteDataSource,
    required this._localDataSource,
  });

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  @override
  Future<AuthSession> login({
    required String fullPhoneNumber,
    required String password,
  }) async {
    debugPrint("AuthRepositoryImpl login Called");
    final request = LoginRequestModel(
      fullPhoneNumber: fullPhoneNumber,
      password: password,
    );

    final response = await _remoteDataSource.login(request);
    final session = response.toEntity();

    await _localDataSource.saveSession(session);

    final accessToken = await _localDataSource.getAccessToken();
    debugPrint(accessToken == null ? "no token" : "token available");

    return session;
  }

  @override
  Future<AuthSession?> restoreSession() async {
    debugPrint("AuthRepositoryImpl restoreSession Called");
    final accessToken = await _localDataSource.getAccessToken();

    final refreshToken = await _localDataSource.getRefreshToken();

    final hasAccessToken = accessToken != null && accessToken.isNotEmpty;

    final hasRefreshToken = refreshToken != null && refreshToken.isNotEmpty;

    if (!hasAccessToken && !hasRefreshToken) {
      return null;
    }

    try {
      final user = await _remoteDataSource.getCurrentUser();

      final newAccessToken = await _localDataSource.getAccessToken();

      final newRefreshToken = await _localDataSource.getRefreshToken();

      if (newAccessToken == null || newRefreshToken == null) {
        await _localDataSource.clearSession();
        return null;
      }

      return AuthSession(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
        user: user.toEntity(),
      );
    } on UnauthorizedFailure {
      await _localDataSource.clearSession();

      return null;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    debugPrint("AuthRepositoryImpl getCurrentUser Called");
    final user = await _remoteDataSource.getCurrentUser();
    return user.toEntity();
  }

  @override
  Future<void> logout() {
    debugPrint("AuthRepositoryImpl logout Called");
    return _localDataSource.clearSession();
  }
}
