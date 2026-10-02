import 'package:dio/dio.dart';

class RequestOptionsConfig {
  const RequestOptionsConfig._();

  static const requiresAuthKey = 'requiresAuth';
  static const authRetryKey = 'authRetry';

  static Options public() {
    return Options(extra: {requiresAuthKey: false});
  }

  static Options authenticated() {
    return Options(extra: {requiresAuthKey: true});
  }
}
