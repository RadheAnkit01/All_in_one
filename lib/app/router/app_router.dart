import 'package:all_in_one/features/auth/presentation/screens/session_restore_error_screen.dart';
import 'package:all_in_one/features/auth/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import 'router_refresh_notifier.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(routerRefreshNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),
      GoRoute(
        path: '/session-error',
        builder: (context, state) {
          return const SessionRestoreErrorScreen();
        },
      ),
    ],
    // redirect: (context, state) {
    //   final authState = ref.read(authProvider);

    //   final isLoading = authState.isLoading;
    //   final isAuthenticated = authState.value != null;

    //   final location = state.matchedLocation;

    //   final isSplash = location == '/splash';
    //   final isLogin = location == '/login';

    //   if (isLoading) {
    //     return isSplash ? null : '/splash';
    //   }

    //   if (!isAuthenticated) {
    //     return isLogin ? null : '/login';
    //   }

    //   if (isAuthenticated && (isLogin || isSplash)) {
    //     return '/';
    //   }

    //   return null;
    // },
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      final location = state.matchedLocation;

      final isSplash = location == '/splash';
      final isLogin = location == '/login';
      final isSessionError = location == '/session-error';

      // If we have an existing value, use it.
      if (authState.hasValue) {
        final isAuthenticated = authState.value != null;
        if (!isAuthenticated) {
          return isLogin ? null : '/login';
        }
        if (isLogin || isSplash || isSessionError) {
          return '/';
        }
        return null;
      }
      // Session restoration is still running.
      if (authState.isLoading) {
        return isSplash ? null : '/splash';
      }
      // Session verification failed. Do NOT log the user out.
      if (authState.hasError) {
        return isSessionError ? null : '/session-error';
      }
      return '/splash';
    },
  );
});
