import 'dart:async';

import 'package:all_in_one/features/auth/auth_provider.dart';
import 'package:all_in_one/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_session.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthSession?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<AuthSession?> {
  late final AuthRepository _authRepository;

  @override
  Future<AuthSession?> build() async {
    _authRepository = ref.read(authRepositoryProvider);

    return _authRepository.restoreSession();
  }

  Future<void> login({
    required String fullPhoneNumber,
    required String password,
  }) async {
    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      final session = await _authRepository.login(
        fullPhoneNumber: fullPhoneNumber,
        password: password,
      );

      state = AsyncData(session);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    } finally {
      ref.read(loginLoadingProvider.notifier).state = false;
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await _authRepository.logout();

      return null;
    });
  }

  Future<void> retry() async {
    ref.invalidateSelf();
  }
}
