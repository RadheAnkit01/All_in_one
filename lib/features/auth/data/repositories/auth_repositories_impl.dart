import 'package:all_in_one/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:all_in_one/features/auth/data/models/login_request_model.dart';
import 'package:all_in_one/features/auth/domain/entities/auth_session.dart';
import 'package:all_in_one/features/auth/domain/repositories/auth_repositories.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this._remoteDataSource});

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<AuthSession> login({
    required String fullPhoneNumber,
    required String password,
  }) async {
    final request = LoginRequestModel(
      fullPhoneNumber: fullPhoneNumber,
      password: password,
    );

    final response = await _remoteDataSource.login(request);

    return response.toEntity();
  }
}
