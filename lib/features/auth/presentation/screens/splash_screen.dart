import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("SplashScreen : build");
    return Scaffold(
      appBar: AppBar(title: const Text('Splash Screen')),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
