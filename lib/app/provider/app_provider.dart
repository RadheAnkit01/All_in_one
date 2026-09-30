import 'package:all_in_one/app/config/app_config.dart';
import 'package:all_in_one/core/network/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return const AppConfig(
    appName: 'Architecture Lab',
    baseUrl: 'https://example.com/api',
  );
});

final dioClientProvider = Provider<DioClient>((ref) {
  final config = ref.watch(appConfigProvider);
  return DioClient(config: config);
});
