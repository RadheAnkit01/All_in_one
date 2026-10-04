import 'package:dio/dio.dart';

import '../errors/app_failures.dart';
import '../errors/failure.dart';

class DioErrorMapper {
  const DioErrorMapper._();

  static Failure map(DioException error) {
    final statusCode = error.response?.statusCode;

    switch (statusCode) {
      case 401:
      case 498:
        return const UnauthorizedFailure();

      case 400:
      case 422:
        return ValidationFailure(message: _extractMessage(error));

      case 500:
      case 502:
      case 503:
      case 504:
        return const ServerFailure();

      default:
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
          case DioExceptionType.connectionError:
            return const NetworkFailure();

          default:
            return const UnknownFailure();
        }
    }
  }

  static String _extractMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];

      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return 'Invalid request.';
  }
}
