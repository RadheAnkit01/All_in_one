import 'package:all_in_one/core/errors/failure.dart';
import 'package:dio/dio.dart';

class DioErrorMapper {
  const DioErrorMapper._();

  static Failure map(DioException exception) {
    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.sendTimeout ||
        exception.type == DioExceptionType.receiveTimeout) {
      return const TimeoutFailure();
    }

    if (exception.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }

    final statusCode = exception.response?.statusCode;

    switch (statusCode!) {
      case 401:
        return const UnauthorizedFailure();

      case 404:
        return const NotFoundFailure();

      case 400:
      case 422:
        return ValidationFailure(
          _extractMessage(exception) ?? 'The request contains invalid data.',
        );

      case >= 500:
        return const ServerFailure();

      default:
        return UnknownFailure(
          _extractMessage(exception) ?? 'Something went wrong.',
        );
    }
  }

  static String? _extractMessage(DioException exception) {
    final data = exception.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];

      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return null;
  }
}
