import 'package:all_in_one/app/config/app_config.dart';
import 'package:dio/dio.dart';

class DioClient {
  DioClient({required AppConfig config})
    : dio = Dio(
        BaseOptions(
          baseUrl: config.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        ),
      );

  final Dio dio;
}
