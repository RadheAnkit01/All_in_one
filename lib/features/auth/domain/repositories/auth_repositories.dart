import 'package:all_in_one/features/auth/domain/entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<AuthSession> login({
    required String fullPhoneNumber,
    required String password,
  });
}
