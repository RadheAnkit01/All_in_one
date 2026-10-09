import 'package:all_in_one/features/auth/domain/entities/auth_session.dart';
import 'package:all_in_one/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<AuthSession> login({
    required String fullPhoneNumber,
    required String password,
  });
  Future<AuthSession?> restoreSession();
  Future<User> getCurrentUser();
  Future<void> logout();
}
