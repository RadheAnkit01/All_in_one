// import 'package:all_in_one/app/provider/app_provider.dart';
import 'package:all_in_one/core/errors/failure.dart';
import 'package:all_in_one/features/auth/auth_provider.dart';
import 'package:all_in_one/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authProvider).value;
    final isLoggingOut = ref.watch(logoutLoadingProvider);
    final currentUserAsync = ref.watch(currentUserProvider);

    ref.listen<Failure?>(logoutErrorProvider, (previous, failure) {
      if (failure == null) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message)));
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Logout',
            onPressed: isLoggingOut
                ? null
                : () {
                    ref.read(authProvider.notifier).logout();
                  },
            icon: isLoggingOut
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout),
          ),
        ],
      ),
      body: currentUserAsync.when(
        data: (user) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            Text('Hello, ${session?.user.fname ?? "User"}!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/profile');
              },
              child: const Text('Go to Profile'),
            ),
          ],
        ),
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          final message = error is Failure
              ? error.message
              : 'Unable to load your profile.';

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(currentUserProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                context.go('/profile');
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                ref.read(authProvider.notifier).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
