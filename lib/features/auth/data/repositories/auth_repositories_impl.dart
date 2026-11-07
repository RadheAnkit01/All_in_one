import 'package:all_in_one/core/errors/app_failures.dart';
import 'package:all_in_one/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:all_in_one/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:all_in_one/features/auth/data/datasource/user_local_data_source.dart';
import 'package:all_in_one/features/auth/data/models/login_request_model.dart';
import 'package:all_in_one/features/auth/domain/entities/auth_session.dart';
import 'package:all_in_one/features/auth/domain/entities/user.dart';
import 'package:all_in_one/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter/cupertino.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this._remoteDataSource,
    required this._localDataSource,
    required this._userLocalDataSource,
  });

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final UserLocalDataSource _userLocalDataSource;
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
    debugPrint(accessToken == null ? "token not available" : "token available");

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
      final user = await getCurrentUser();

      final newAccessToken = await _localDataSource.getAccessToken();

      final newRefreshToken = await _localDataSource.getRefreshToken();

      if (newAccessToken == null || newRefreshToken == null) {
        await _localDataSource.clearSession();
        return null;
      }

      return AuthSession(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
        user: user,
      );
    } on UnauthorizedFailure {
      await _localDataSource.clearSession();
      await _userLocalDataSource.clearCurrentUser();

      return null;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    debugPrint("AuthRepositoryImpl getCurrentUser Called");
    try {
      // 1. Fetch from backend.
      final userModel = await _remoteDataSource.getCurrentUser();
      // 2. Save successful response to SQLite.
      await _userLocalDataSource.saveCurrentUser(userModel);
      // 3. Return domain entity.
      return userModel.toEntity();
    } on NetworkFailure {
      // Backend unavailable or connection failed.
      final cachedUser = await _userLocalDataSource.getCurrentUser();
      if (cachedUser != null) {
        return cachedUser;
      }
      // No cached data: preserve the original failure.
      rethrow;
    } on ServerFailure {
      // Server returned an unavailable/error response.
      final cachedUser = await _userLocalDataSource.getCurrentUser();
      if (cachedUser != null) {
        return cachedUser;
      }
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    debugPrint("AuthRepositoryImpl logout Called");
    _localDataSource.clearSession();
    _userLocalDataSource.clearCurrentUser();
  }
}
