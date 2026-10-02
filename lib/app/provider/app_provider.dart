import 'package:all_in_one/app/config/app_config.dart';
import 'package:all_in_one/core/network/dio_client.dart';
import 'package:all_in_one/core/storage/flutter_secure_storage_service.dart';
import 'package:all_in_one/core/storage/secure_storage.dart';
import 'package:all_in_one/core/storage/secure_token_storage.dart';
import 'package:all_in_one/core/storage/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return const AppConfig(
    appName: 'Architecture Lab',
    baseUrl: 'http://localhost:8080/api/v1',
  );
});

final dioClientProvider = Provider<DioClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return DioClient(config: config, tokenStorage: tokenStorage);
});

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return FlutterSecureStorageService();
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return SecureTokenStorage(secureStorage: ref.watch(secureStorageProvider));
});
