import 'package:all_in_one/app/config/app_config.dart';
import 'package:all_in_one/core/errors/failure.dart';
import 'package:all_in_one/core/network/dio_error_mapper.dart';
import 'package:all_in_one/core/network/interceptors/auth_interceptor.dart';
import 'package:all_in_one/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';

class DioClient {
  DioClient({required AppConfig config, required SecureStorage secureStorage})
    : _dio = Dio(
        BaseOptions(
          baseUrl: config.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        ),
      ) {
    _dio.interceptors.add(AuthInterceptor(secureStorage: secureStorage));
  }

  final Dio _dio;

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (error) {
      throw DioErrorMapper.map(error);
    } on Failure {
      rethrow;
    } catch (_) {
      throw const UnknownFailure();
    }
  }
}
