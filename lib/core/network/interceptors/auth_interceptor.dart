import 'package:dio/dio.dart';

import '../../storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this._dio,
    required String baseUrl,
    required this._tokenStorage,
  }) : _refreshDio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 10),
           receiveTimeout: const Duration(seconds: 10),
           sendTimeout: const Duration(seconds: 10),
           responseType: ResponseType.json,
         ),
       );

  final Dio _dio;
  final Dio _refreshDio;
  final TokenStorage _tokenStorage;

  Future<void>? _refreshFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final requiresAuth = options.extra['requiresAuth'] != false;

    if (!requiresAuth) {
      handler.next(options);
      return;
    }

    final accessToken = await _tokenStorage.getAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;

    final requiresAuth = options.extra['requiresAuth'] != false;

    final alreadyRetried = options.extra['authRetry'] == true;

    final isUnauthorized = err.response?.statusCode == 401;

    if (!requiresAuth || !isUnauthorized || alreadyRetried) {
      handler.next(err);
      return;
    }

    try {
      await _refreshAccessToken();

      final newAccessToken = await _tokenStorage.getAccessToken();

      if (newAccessToken == null || newAccessToken.isEmpty) {
        handler.next(err);
        return;
      }

      options.extra['authRetry'] = true;

      options.headers['Authorization'] = 'Bearer $newAccessToken';

      final response = await _dio.fetch<dynamic>(options);

      handler.resolve(response);
    } on DioException catch (refreshError) {
      handler.next(refreshError);
    } catch (_) {
      handler.next(err);
    }
  }

  Future<void> _refreshAccessToken() {
    final existingRefresh = _refreshFuture;

    if (existingRefresh != null) {
      return existingRefresh;
    }

    final future = _performRefresh();

    _refreshFuture = future;

    future.then(
      (_) {
        if (identical(_refreshFuture, future)) {
          _refreshFuture = null;
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (identical(_refreshFuture, future)) {
          _refreshFuture = null;
        }
      },
    );

    return future;
  }

  Future<void> _performRefresh() async {
    final refreshToken = await _tokenStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      throw StateError('No refresh token available.');
    }

    final response = await _refreshDio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );

    final data = response.data;

    if (data == null) {
      throw StateError('Refresh response was empty.');
    }

    final accessToken = data['accessToken'] as String?;

    final newRefreshToken = data['refreshToken'] as String?;

    if (accessToken == null ||
        accessToken.isEmpty ||
        newRefreshToken == null ||
        newRefreshToken.isEmpty) {
      throw StateError('Refresh response did not contain valid tokens.');
    }

    await _tokenStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: newRefreshToken,
    );
  }
}
