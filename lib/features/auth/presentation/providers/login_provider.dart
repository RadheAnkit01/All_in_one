import 'dart:async';

import 'package:all_in_one/features/auth/auth_provider.dart';
import 'package:all_in_one/features/auth/domain/entities/auth_session.dart';
import 'package:all_in_one/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginProvider = AsyncNotifierProvider<LoginNotifier, AuthSession?>(
  LoginNotifier.new,
);

class LoginNotifier extends AsyncNotifier<AuthSession?> {
  late final AuthRepository _authRepository;
  @override
  FutureOr<AuthSession?> build() {
    _authRepository = ref.read(authRepositoryProvider);
    return null;
  }

  Future<void> login({
    required String fullPhoneNumber,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return _authRepository.login(
        fullPhoneNumber: fullPhoneNumber,
        password: password,
      );
    });
  }
}
