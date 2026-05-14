import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      headers: const {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(_RetryInterceptor(dio));
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (e, handler) {
        if (kDebugMode) {
          debugPrint('Dio error: ${e.message} ${e.response?.statusCode}');
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
}

/// Retries on transient server errors (5xx) and timeouts, up to [maxRetries].
class _RetryInterceptor extends Interceptor {
  _RetryInterceptor(this._dio);

  final Dio _dio;
  static const int maxRetries = 3;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = err.requestOptions.extra['_retryCount'] as int? ?? 0;
    final isRetryable = _shouldRetry(err);

    if (isRetryable && attempt < maxRetries) {
      err.requestOptions.extra['_retryCount'] = attempt + 1;
      // Exponential back-off: 1 s, 2 s, 4 s
      await Future<void>.delayed(Duration(seconds: 1 << attempt));
      try {
        final response = await _dio.fetch<dynamic>(err.requestOptions);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.next(e);
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    final status = err.response?.statusCode;
    if (status != null && status >= 500) return true;
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout;
  }
}
