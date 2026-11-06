import 'dart:async';

import 'package:all_in_one/app/provider/session_expiry_provider.dart';
import 'package:all_in_one/core/errors/app_failures.dart';
import 'package:all_in_one/core/errors/failure.dart';
import 'package:all_in_one/core/network/network_retry_policy.dart';
import 'package:all_in_one/features/auth/auth_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_session.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthSession?>(
  AuthNotifier.new,
  retry: networkRetryPolicy,
);

class AuthNotifier extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    debugPrint('🔵 AuthNotifier BUILD');

    ref.onDispose(() {
      debugPrint('🔴 AuthNotifier DISPOSED');
    });
    ref.listen<int>(sessionExpiryProvider, (previous, next) {
      if (next > (previous ?? 0)) {
        state = const AsyncData<AuthSession?>(null);
      }
    });

    return ref.watch(authRepositoryProvider).restoreSession();
  }

  Future<void> login({
    required String fullPhoneNumber,
    required String password,
  }) async {
    ref.read(loginLoadingProvider.notifier).state = true;
    ref.read(loginErrorProvider.notifier).state = null;

    try {
      final repository = ref.read(authRepositoryProvider);

      final session = await repository.login(
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
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
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

  Future<void> retryRestoreSession() async {
    state = const AsyncLoading<AuthSession?>();

    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).restoreSession(),
    );
  }
}
