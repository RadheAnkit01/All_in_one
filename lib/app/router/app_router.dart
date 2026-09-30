import 'package:all_in_one/features/auth/presentation/screens/login_screen.dart';
import 'package:all_in_one/features/home/presentation/screens/home_screen.dart';
import 'package:all_in_one/features/profile/presentation/screens/profile_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),
    ],
  );
}
