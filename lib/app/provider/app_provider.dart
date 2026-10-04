import 'package:all_in_one/app/config/app_config.dart';
import 'package:all_in_one/core/network/dio_client.dart';
import 'package:all_in_one/core/network/interceptors/auth_interceptor.dart';
import 'package:all_in_one/core/storage/flutter_secure_storage_service.dart';
import 'package:all_in_one/core/storage/secure_storage.dart';
import 'package:all_in_one/core/storage/secure_token_storage.dart';
import 'package:all_in_one/core/storage/token_storage.dart';
import 'package:dio/dio.dart';
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
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(
      dio: dio,
      baseUrl: config.baseUrl,
      tokenStorage: tokenStorage,
    ),
  );
  return DioClient(dio: dio);
});

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return FlutterSecureStorageService();
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return SecureTokenStorage(secureStorage: ref.watch(secureStorageProvider));
});
