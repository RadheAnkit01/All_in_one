import 'dart:async';

import 'package:all_in_one/core/errors/app_failures.dart';
import 'package:all_in_one/core/errors/failure.dart';
import 'package:all_in_one/features/auth/auth_provider.dart';
import 'package:all_in_one/features/auth/domain/entities/user.dart';
import 'package:all_in_one/features/auth/domain/repositories/auth_repositories.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_session.dart';

final currentUserProvider = FutureProvider.autoDispose<User>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.getCurrentUser();
});

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
    ref.read(loginErrorProvider.notifier).state = null;

    try {
      final session = await _authRepository.login(
        fullPhoneNumber: fullPhoneNumber,
        password: password,
      );

      state = AsyncData(session);
    } on Failure catch (failure) {
      ref.read(loginErrorProvider.notifier).state = failure;
    } catch (_) {
      ref.read(loginErrorProvider.notifier).state = const UnknownFailure();
    } finally {
      ref.read(loginLoadingProvider.notifier).state = false;
    }
  }

  Future<void> logout() async {
    ref.read(logoutLoadingProvider.notifier).state = true;
    ref.read(logoutErrorProvider.notifier).state = null;

    try {
      await _authRepository.logout();
      state = const AsyncData(null);
    } on Failure catch (failure) {
      ref.read(logoutErrorProvider.notifier).state = failure;
    } catch (error, stackTrace) {
      debugPrint('Logout failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      ref.read(logoutErrorProvider.notifier).state = const UnknownFailure();
    } finally {
      ref.read(logoutLoadingProvider.notifier).state = false;
    }
  }

  Future<void> retry() async {
    ref.invalidateSelf();
  }
}
