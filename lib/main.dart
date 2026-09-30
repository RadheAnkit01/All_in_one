import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

/*

Why are we doing this?
  main.dart has one job:
  Start the application.

It shouldn't eventually contain:
  Dio setup
  Riverpod
  Router
  Theme
  Database
  Authentication
  Storage

Those are application concerns, not startup concerns.
*/
