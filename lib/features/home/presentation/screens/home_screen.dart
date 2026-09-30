// import 'package:all_in_one/app/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final dioClient = ref.watch(dioClientProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/profile');
          },
          child: const Text('Go to Profile'),
        ),
      ),
      // body: Center(child: Text(dioClient.dio.options.baseUrl)),
    );
  }
}
