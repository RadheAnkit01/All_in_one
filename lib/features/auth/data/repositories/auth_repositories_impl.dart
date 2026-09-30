import 'package:all_in_one/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:all_in_one/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:all_in_one/features/auth/data/models/login_request_model.dart';
import 'package:all_in_one/features/auth/domain/entities/auth_session.dart';
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
    debugPrint("authRepo called");
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
}
