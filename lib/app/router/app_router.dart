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
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      final isLoading = authState.isLoading;
      final isAuthenticated = authState.value != null;

      final location = state.matchedLocation;

      final isSplash = location == '/splash';
      final isLogin = location == '/login';

      if (isLoading) {
        return isSplash ? null : '/splash';
      }

      if (!isAuthenticated) {
        return isLogin ? null : '/login';
      }

      if (isAuthenticated && (isLogin || isSplash)) {
        return '/';
      }

      return null;
    },
  );
});
